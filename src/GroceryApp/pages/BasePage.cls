Class GroceryApp.pages.BasePage Extends %CSP.Page
{

ClassMethod RenderHeaderAndApplyStyles() As %Status
{
        set const = ##class(GroceryApp.utils.Constants).%New()
        set isAuthenticated = %session.Get("isAuthenticated")
        set dashboardLink = ##class(%CSP.Page).Link(const.#PRODUCTLISTPAGENAME)
        set loginLink = ##class(%CSP.Page).Link(const.#LOGINPAGENAME)
        set logoutLink = ##class(%CSP.Page).Link(const.#LOGOUTPAGENAME)
        set registerLink = ##class(%CSP.Page).Link(const.#REGISTERPAGENAME)
        set orderListLink = ##class(%CSP.Page).Link(const.#ORDERLISTPAGENAME)
        set requestPageName = %request.PageName

        set adminUserManageLink = ##class(%CSP.Page).Link(const.#USERMANAGEPAGENAME)
        set adminProductManageLink = ##class(%CSP.Page).Link(const.#MANAGEPRODUCTPAGENAME)
            
        set cartLink = ##class(%CSP.Page).Link(const.#CARTPAGENAME)

        &html<
            <head>
            <style type="text/css">
                .product-detail-container{
                    max-width: 800px;
                    margin: 50px auto;
                    margin-top: 120px;
                    padding: 20px;
                    background: #fff;
                    border-radius: 8px;
                    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                }
                .product-details {
                    display: flex;
                    gap: 20px;
                }
                .product-image {
                    flex: 1;
                    max-width: 250px;
                }
 
            </style>
            </head>
            <header>
                <div class="header">
                    <a href="#(dashboardLink)#" class="logo">
                        <img src="https://seeklogo.com/images/G/grocery-store-logo-3B65A40953-seeklogo.com.png" alt="Grocery Store Logo" class="logo">
                    </a>
                    <div class="header-right">
        >               
        set activeClass = "class='active'"

        if requestPageName = const.#PRODUCTLISTPAGENAME {
            w "<a href='"_dashboardLink_"' "_activeClass_">Products</a>"
        } else {
            w "<a href='"_dashboardLink_"'>Products</a>"
        }

        if isAuthenticated {
            if requestPageName = const.#MANAGEPRODUCTPAGENAME {
                w "<a href='"_adminProductManageLink_"' "_activeClass_">Product Manage</a>"
            } else {
                w "<a href='"_adminProductManageLink_"'>Product Manage</a>"
            }

            if requestPageName = const.#USERMANAGEPAGENAME {
                w "<a href='"_adminUserManageLink_"' "_activeClass_">User Manage</a>"
            } else {
                w "<a href='"_adminUserManageLink_"'>User Manage</a>"
            }

            if requestPageName = const.#ORDERLISTPAGENAME {
                w "<a href='"_orderListLink_"' "_activeClass_">Your orders</a>"
            } else {
                w "<a href='"_orderListLink_"'>Your orders</a>"
            }

            if requestPageName = const.#CARTPAGENAME {
                w "<a href='"_cartLink_"' "_activeClass_">Cart</a>"
            } else {
                w "<a href='"_cartLink_"'>Cart</a>"
            }
                                
            w "<a href='"_logoutLink_"'>Log out</a>"
        } 
        elseif requestPageName = const.#LOGINPAGENAME {
            w "<a href='"_registerLink_"'>Register</a>"
        }
        elseif requestPageName = const.#REGISTERPAGENAME {
            w "<a href='"_loginLink_"'>Log in</a>"
        } else {
            w "<a href='"_loginLink_"'>Log in</a>"
        }
        &html<
                    </div>
                </div>
            </header>
        >

        quit $$$OK
}

}
