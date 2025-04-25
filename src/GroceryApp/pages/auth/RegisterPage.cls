Class GroceryApp.pages.auth.RegisterPage Extends GroceryApp.pages.BasePage
{

ClassMethod OnPage() As %Status
{
    set const = ##class(GroceryApp.utils.Constants).%New()
    set registerLink = ##class(%CSP.Page).Link(const.#REGISTERPAGENAME)
    set loginLink = ##class(%CSP.Page).Link(const.#LOGINPAGENAME)
    set error = $Get(%request.Data("error"))
    set success = $Get(%request.Data("success"))

    if $Get(%request.Data("submit")) '= "" {
        // Получение данных формы
        set firstName = $Get(%request.Data("firstName"))
        set lastName = $Get(%request.Data("lastName"))
        set email = $Get(%request.Data("email"))
        set password = $Get(%request.Data("password"))
        set regionName = $Get(%request.Data("region"))

        // Проверка заполненности
        if firstName = "" || lastName = "" || email = "" || password = "" || regionName = "" {
            do ..RedirectWithError(registerLink, "MissingFieldsError")
            quit $$$OK
        }

        // Проверка валидности региона
        set region = ##class(GroceryApp.data.Region).%OpenByKey(regionName)
        if '$IsObject(region) {
            do ..RedirectWithError(registerLink, const.#INVALIDREGIONERR)
            quit $$$OK
        }

        // Проверка уникальности email
        zn "%SYS" // переход в %SYS для работы с Security.Users
        set userObj = ""
        $$$THROWONERROR(tSC, ##class(Security.Users).Get(email, .userObj))
        zn "APP"
        if $IsObject(userObj) {
            do ..RedirectWithError(registerLink, "EmailAlreadyExists")
            quit $$$OK
        }

        // Регистрация пользователя
        TSTART
        try {
            zn "%SYS"
            set newUser = ##class(Security.Users).%New()
            set newUser.Name = email
            set newUser.Password = password
            set newUser.Enabled = 1
            set newUser.Roles = "%All, Purchaser"
            $$$THROWONERROR(tSC, newUser.%Save())
            zn "APP"

            // Привязка к региону
            set userRegion = ##class(GroceryApp.data.UserRegion).%New()
            set userRegion.UserName = email
            set userRegion.Region = region
            $$$THROWONERROR(tSC, userRegion.%Save())

            // Создание пустой корзины
            set cart = ##class(GroceryApp.data.Cart).%New()
            set cart.UserName = email
            set cart.Status = "New"
            $$$THROWONERROR(tSC, cart.%Save())

            TCOMMIT
            do ..RedirectWithSuccess(loginLink, "RegisteredSuccessfully")
        }
        catch ex {
            TROLLBACK
            do ..RedirectWithError(registerLink, "RegistrationFailed")
        }
    }

    do ..RenderHeaderAndApplyStyles()

    &html<
    <div class="form-container">
    >

    if error '= "" {
        &html< <div class="centered-error">#($zcvt(error, "O", "HTML"))#</div> >
    }
    elseIf success '= "" {
        &html< <div class="centered-success">#($zcvt(success, "O", "HTML"))#</div> >
    }

    &html<
    <form method="post">
        <input type="text" name="firstName" placeholder="First Name" required/>
        <input type="text" name="lastName" placeholder="Last Name" required/>
        <input type="email" name="email" placeholder="Email" required/>
        <input type="password" name="password" placeholder="Password" required/>
        <select name="region" required>
    >

    set query = "SELECT Name FROM "_const.#REGIONTABLENAME
    set stmt = ##class(%SQL.Statement).%New()
    set status = stmt.%Prepare(query)
    set rset = stmt.%Execute()

    &html< <option value="" disabled selected>Select your region</option> >

    while rset.%Next() {
        set region = rset.%Get("Name")
        &html< <option value="#(region)#">#(region)#</option> >
    }

    &html<
        </select>
        <button type="submit" name="submit">Register</button>
        <button type="button" onclick="window.location.href='#(loginLink)#'">Login</button>
    </form>
    </div>
    >

    quit $$$OK
}

ClassMethod RedirectWithError(link As %String, errorMsg As %String)
{
    w "<script> window.location.href = '"_link_"?error="_errorMsg_"'; </script>"
}

ClassMethod RedirectWithSuccess(link As %String, successMsg As %String)
{
    w "<script> window.location.href = '"_link_"?success="_successMsg_"'; </script>"
}

}
