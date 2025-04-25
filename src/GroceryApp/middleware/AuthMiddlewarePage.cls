Class GroceryApp.middleware.AuthMiddlewarePage Extends GroceryApp.pages.BasePage
{
    ClassMethod OnPreHTTP() As %Boolean
    {
        set const = ##class(GroceryApp.utils.Constants).%New()
        set unauthenticatedUrls = $LISTBUILD(const.#REGISTERPAGENAME, const.#LOGINPAGENAME, const.#ACCESSDENIEDPAGENAME)
        set adminOnlyUrls = $LISTBUILD(const.#MANAGEPRODUCTPAGENAME, const.#USERMANAGEPAGENAME)

        if $LISTFIND(unauthenticatedUrls, %request.PageName) {
            quit 1
        }

        set isAuthenticated = $Get(%session.Data("isAuthenticated"))
        set userId = $Get(%session.Data("userId"))

        if (isAuthenticated '= 1) || (userId = "") {
            set %response.Redirect = const.#LOGINPAGENAME
            quit 0
        }

        // Проверка на админа
        if $LISTFIND(adminOnlyUrls, %request.PageName) {
            if '##class(GroceryApp.middleware.AuthMiddlewarePage).IsAdmin() {
                set %response.Redirect = const.#ACCESSDENIEDPAGENAME
                quit 0
            }
        }

        quit 1
    }

    /// Проверка - админ ли пользователь
    ClassMethod IsAdmin() As %Boolean
    {
        try {
            set userId = $GET(%session.Data("userId"), "")
            if userId = "" return 0

            new $namespace
            zn "%SYS"

            set tUser = ##class(Security.Users).%OpenId(userId)
            if tUser = "" return 0

            return tUser.Roles.Find("CustomAdmin", 0)
        } catch {
            return 0
        }
    }
}