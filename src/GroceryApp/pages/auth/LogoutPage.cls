Class GroceryApp.pages.auth.LogoutPage Extends GroceryApp.pages.BasePage
{

ClassMethod OnPage() As %Status
{
        set const = ##class(GroceryApp.utils.Constants).%New()
        set loginUrl = ##class(%CSP.Page).Link(const.#LOGINPAGENAME)

        do %session.Set("isAuthenticated", 0)
        do %session.Set("email", "")
        do %session.Set("userId", "")
        do %session.Set("isAdmin", 0)
        do %session.Set("cartId", "")
        do %session.Logout()

        // Redirects user to login page after log out
        w "<script> window.location.href = '"_loginUrl_"?success="_const.#LOGOUTSUCCESS_"'; </script>"

        return $$$OK
}

}
