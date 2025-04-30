Class GroceryApp.pages.auth.LoginPage Extends (%CSP.Login, GroceryApp.pages.BasePage)
{

ClassMethod OnPage() As %Status
{
    set const = ##class(GroceryApp.utils.Constants).%New()
    set loginUrl = ##class(%CSP.Page).Link(const.#LOGINPAGENAME)
    set dashboardUrl = ##class(%CSP.Page).Link(const.#PRODUCTLISTPAGENAME)
    set registerUrl = ##class(%CSP.Page).Link(const.#REGISTERPAGENAME)

    set error = $Get(%request.Data("error"))
    set success = $Get(%request.Data("success"))

    if %request.Method = "POST" {
        set email = $Get(%request.Data("email"))
        set password = $Get(%request.Data("password"))

        if (email = "") || (password = "") {
            do ..RedirectWithError(loginUrl, const.#MISSINGFIELDSERROR)
            return $$$OK
        }

        set encodedEmail = $zcvt($zcvt(email,"0","URL"),"L")

        // Validate user against IRIS Security.Users
        try {
            zn "%SYS"
            set tSC = $SYSTEM.Security.Login(encodedEmail, password)
            zn "APP"
        } catch ex {
            zn "APP"
            do ..RedirectWithError(loginUrl, const.#LOGINFAILERROR)
            return $$$OK
        }

        if tSC '= 1 {
            do ..RedirectWithError(loginUrl, const.#LOGINFAILERROR)
            return $$$OK
        }

        // If successful login
        set userId = ##class(GroceryApp.utils.Query).GetId(const.#SECURITYUSERTABLENAME, "ID", encodedEmail, "%SYS")
        set cartId = ""

        &sql(SELECT ID INTO :cartId FROM GroceryApp_data.Cart WHERE UserName = :encodedEmail)

        if cartId = "" {
            set cart = ##class(GroceryApp.data.Cart).%New()
            set cart.UserName = encodedEmail
            set cart.Status = "New"
            do cart.%Save()
            &sql(SELECT ID INTO :cartId FROM GroceryApp_data.Cart WHERE UserName = :encodedEmail)
        }

        // Start session
        do %session.Set("isAuthenticated", 1)
        do %session.Set("email", email)
        do %session.Set("userId", userId)
        do %session.Set("cartId", cartId)

        w "<script> window.location.href = '"_dashboardUrl_"'; </script>"
            
        return $$$OK
    }

    do ..RenderHeaderAndApplyStyles()

    &html<
        <html>
            <body>
                <div class="centered-content-container">
                    <div class="login-form">
                        <h1>Log in</h1>
    >

                        if error '= "" {
                            &html< <div class="centered-error">#($zcvt(error, "O", "HTML"))#</div> >
                        } elseif success '= "" {
                            &html< <div class="centered-success">#($zcvt(success, "O", "HTML"))#</div> >
                        }

    &html<
                        <form method="POST">
                            <label>Email:</label>
                            <input type="email" name="email" required="true"/><br/>

                            <label>Password:</label>
                            <input type="password" name="password" required="true"/><br/>

                            <button class="submit-btn" type="submit" name="submit">Log In</button>
                        </form>
                        <button class="register-btn" onclick="window.location.href='#(registerUrl)#'">Register</button>
                    </div>
                </div>
            </body>
        </html>
    >

    return $$$OK
}

}
