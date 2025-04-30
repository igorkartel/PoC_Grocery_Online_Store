Class GroceryApp.pages.auth.RegisterPage Extends GroceryApp.pages.BasePage
{

ClassMethod OnPage() As %Status
{
    #dim tSC As %Status = $$$OK
    set const = ##class(GroceryApp.utils.Constants).%New()
    set registerLink = ##class(%CSP.Page).Link(const.#REGISTERPAGENAME)
    set loginLink = ##class(%CSP.Page).Link(const.#LOGINPAGENAME)

    set error = $Get(%request.Data("error"))
    set success = $Get(%request.Data("success"))

    if %request.Method = "POST" {
        // Receiving form data
        set firstName = $Get(%request.Data("firstName", 1))
        set lastName = $Get(%request.Data("lastName", 1))
        set email = $Get(%request.Data("email", 1))
        set password = $Get(%request.Data("password", 1))
        set regionName = $Get(%request.Data("region", 1))

        // Checks if all required field are filled in
        if firstName = "" || lastName = "" || email = "" || password = "" || regionName = "" {
            do ..RedirectWithError(registerLink, const.#REQUIREDFIELDSERROR)
            quit $$$OK
        }

        // Checks region validity
        set region = ##class(GroceryApp.data.Region).%OpenByKey(regionName)
        if '$IsObject(region) {
            do ..RedirectWithError(registerLink, const.#INVALIDREGIONERROR)
            quit $$$OK
        }

        //  Switches to the %SYS namesace to handle with Security.Users
        new $namespace
        zn "%SYS"

        // Checks if email is unique
        set encodedEmail = $zcvt($zcvt(email, "O", "URL"), "L") // Encodes email for user Name

        set userObj = ""
        $$$THROWONERROR(tSC, ##class(Security.Users).Get(encodedEmail, .userObj))

        if $IsObject(userObj) {
            do ..RedirectWithError(registerLink, const.#USEREXISTSERROR)
            quit $$$OK
        }

        // User registration
        do ..UserRegistration(firstName, lastName, email, encodedEmail, password, region, loginLink, registerLink, const)
        quit $$$OK
    }

    // Populates region options dynamically
    set regionOptions = ""
    set query = "SELECT * FROM "_const.#REGIONTABLENAME
    set rset = ##class(%SQL.Statement).%ExecDirect(, query)

    while rset.%Next() {
        set regionOptions = regionOptions_"<option value='"_rset.Name_"'>"_rset.Name_"</option>"
    }

    do ..RenderHeaderAndApplyStyles()

    &html<
        <html>
            <body>
                <div class="centered-content-container">
                    <div class="register-form">
                        <h1>Register</h1>
    >

                        if error '= "" {
                            &html< <div class="centered-error">#($zcvt(error, "O", "HTML"))#</div> >
                        }
                        elseIf success '= "" {
                            &html< <div class="centered-success">#($zcvt(success, "O", "HTML"))#</div> >
                        }

    &html<
                        <form method="POST">
                            <label>First Name:</label>
                            <input type="text" name="firstName" placeholder="First Name" required="true"/><br/>

                            <label>Last Name:</label>
                            <input type="text" name="lastName" placeholder="Last Name" required="true"/><br/>
                            
                            <label>Email:</label>
                            <input type="email" name="email" placeholder="Email" required="true"/><br/>

                            <label>Password:</label>
                            <input type="password" name="password" placeholder="Password" required="true"/><br/>

                            <label>Region:</label>
                            <select name="region" id="region-select" required="true">
                                <option value="" disabled selected>Select your region</option>
    >
                                w regionOptions

    &html< 
                            </select><br/>

                            <button class="submit-btn" type="submit" name="submit">Register</button>
                            <button class="login-btn" type="button" onclick="window.location.href='#(loginLink)#'">Log in</button>
                        </form>
                    </div>
                </div>
            </body>
        </html>
    >

    quit $$$OK
}

ClassMethod UserRegistration(firstName As %String, lastName As %String, email As %String, encodedEmail As %String, password As %String, region As GroceryApp.data.Region, loginLink As %String, registerLink As %String, const) As %Status
{
    new $namespace
    set tSC = $$$OK

    try {
        // Start a transaction
        TSTART

        // Create a new user
        set $namespace = "%SYS"

        set newUser = ##class(Security.Users).%New()
        set newUser.Name = encodedEmail
        set newUser.Password = password
        set newUser.FullName = firstName_" "_lastName
        set newUser.EmailAddress = email
        set newUser.Enabled = 1
        set newUser.Roles = "%All, Purchaser"
        $$$THROWONERROR(tSC, newUser.%Save())

        // Connect new user to region
        set $namespace = "APP"

        set userRegion = ##class(GroceryApp.data.UserRegion).%New()
        set userRegion.UserName = encodedEmail
        set userRegion.Region = region
        $$$THROWONERROR(tSC, userRegion.%Save())

        // Create an empty user's cart
        set cart = ##class(GroceryApp.data.Cart).%New()
        set cart.UserName = encodedEmail
        set cart.Status = "New"
        $$$THROWONERROR(tSC, cart.%Save())

        // Commit a transaction
        TCOMMIT
        do ..RedirectWithSuccess(loginLink, const.#REGISTRATIONSUCCESS)
        quit $$$OK
    }
    catch ex {
        // Rollback a transaction if any error occurs
        TROLLBACK
        do ..RedirectWithError(registerLink, const.#REGISTRATIONFAILED)
        quit ex.AsStatus()
    }
}

}
