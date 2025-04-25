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

        if $Get(%request.Data("submit")) '= "" {
            set email = $Get(%request.Data("email"))
            set password = $Get(%request.Data("password"))

            if (email = "") || (password = "") {
                do ..RedirectWithError(loginUrl, const.#MISSINGFIELDSERR)
                return $$$OK
            }

            set encodedEmail = $zcvt($replace(email,"@","%40"),"L") // safe email

            try {
                zn "%SYS"
                set tSC = $SYSTEM.Security.Login(encodedEmail, password)
                zn "APP"
            } catch ex {
                zn "APP"
                do ..RedirectWithError(loginUrl, const.#LOGINFAILERR)
                return $$$OK
            }

            if tSC '= 1 {
                do ..RedirectWithError(loginUrl, const.#LOGINFAILERR)
                return $$$OK
            }

            // Успешный логин
            set userId = ##class(GroceryApp.utils.Query).GetId(const.#SECURITYUSERTABLENAME, "ID", encodedEmail, "%SYS")
            set cartId = ""

            &sql(SELECT ID INTO :cartId FROM GroceryApp.data.Cart WHERE UserName = :encodedEmail)
            if cartId = "" {
                set cart = ##class(GroceryApp.data.Cart).%New()
                set cart.UserName = encodedEmail
                set cart.Status = "New"
                do cart.%Save()
                &sql(SELECT ID INTO :cartId FROM GroceryApp.data.Cart WHERE UserName = :encodedEmail)
            }

            do %session.Set("isAuthenticated", 1)
            do %session.Set("email", encodedEmail)
            do %session.Set("userId", userId)
            do %session.Set("cartId", cartId)

            w "<script> window.location.href = '"_dashboardUrl_"'; </script>"
            
            return $$$OK
        }

        do ..RenderHeaderAndApplyStyles()

        &html<
        <div class="form-container">
        >

        if error '= "" {
            &html< <div class="centered-error">#($zcvt(error, "O", "HTML"))#</div> >
        } elseif success '= "" {
            &html< <div class="centered-success">#($zcvt(success, "O", "HTML"))#</div> >
        }

        &html<
        <form method="post">
            <label>Email:</label>
            <input type="email" name="email" required/><br/>
            <label>Password:</label>
            <input type="password" name="password" required/><br/>
            <button class="submit-btn" type="submit" name="submit">Log In</button>
        </form>
        <button class="register-btn" onclick="window.location.href='#(registerUrl)#'">Register</button>
        </div>
        >

        return $$$OK
}

ClassMethod RedirectWithError(link As %String, errorMsg As %String)
{
        w "<script> window.location.href = '"_link_"?error="_errorMsg_"'; </script>"
}

}
