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
            .product-image img {
                width: 100%;
                height: auto;
                border-radius: 8px;
                border: 1px solid #ddd;
            }
            .product-info {
                flex: 2;
                display: flex;
                flex-direction: column;
                gap: 10px;
            }
            .product-info h1 {
                margin: 0;
                font-size: 24px;
                color: #444;
            }
            .product-info p {
                margin: 5px 0;
                line-height: 1.6;
            }
            .actions {
                margin-top: 20px;
                display: flex;
                gap: 10px;
                align-items: center;
            }
            .detail-form {
                margin: 0;
            }
            .input-description {
                width: 100%;
                max-width: 300px;
                min-height: 100px;
                padding: 10px;
                font-size: 16px;
                font-family: Arial, sans-serif;
                border: 1px solid #ccc;
                border-radius: 5px;
                resize: vertical;
                box-sizing: border-box;
            }
            .input-description:focus {
                border-color: #007BFF;
                outline: none;
                box-shadow: 0 0 5px rgba(0, 123, 255, 0.5);
            }
            .logo {
                width: 50px; 
                height: auto;
            }
            .header {
                display: flex;
                align-items: center;
                justify-content: space-between;
                padding: 10px 20px;
                background-color: #f4f4f4;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            .cart {
                max-width: 800px;
                margin: 100px auto;
                padding: 20px;
                border: 1px solid #ddd;
                border-radius: 5px;
                background-color: #f9f9f9;
            }
            .blue-btn, .disabled-blue-btn {
                padding: 10px 15px;
                background-color: #007bff;
                color: white;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }
            .disabled-blue-btn {
                background-color: #9797a5b5;
            }
            .blue-btn:hover {
                background-color: #0056b3;
            }
            .view-cart-btn, .back-to-product-btn{
                font-size: 13px;
                display: inline-block;
                padding: 10px 15px;
                background-color: #4CAF50;
                color: #fff;
                text-decoration: none;
                border-radius: 4px;
            }
            .view-cart-btn:hover, .back-to-product-btn:hover {
                background-color: #45a049;
            }
            .btn-delete {
                cursor: pointer;
                padding: 5px 10px;
                background-color: #dc3545;
                border-radius: 5px;
            }
            .btn-update {
                cursor: pointer;
                padding: 5px 10px;
                border-radius: 5px;
            }
            .btn-update:hover {
                background-color:rgb(148, 148, 148);
            }
            .btn-delete:hover {
                background-color: #a71d2a;
            }
            .slider-container {
                position: relative;
                width: 100%;
                max-width: 600px;
                margin: auto;
            }
            .slider {
                display: flex;
                overflow: hidden;
                width: 100%;
                max-width: 600px;
                height: 400px;
            }
            .slide {
                display: none;
                flex: 0 0 100%;
                text-align: center;
            }
            .slide img {
                width: 100%;
                height: 300px;
                object-fit: cover;
                border-radius: 8px;
            }
            .prev, .next {
                cursor: pointer;
                position: absolute;
                top: 50%;
                transform: translateY(-50%);
                background-color: rgba(0,0,0,0.5);
                color: white;
                font-size: 18px;
                padding: 8px;
                border: none;
                border-radius: 50%;
                z-index: 1;
            }
            .prev {
                left: 10px;
            }
            .next {
                right: 10px;
            }
            .filters {
                display: flex;
                justify-content: space-between;
                align-items: center;
                background-color: #fff;
                padding: 20px;
                border-radius: 8px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }
            .submit-filters{
                background-color: #007bff;
                color: white;
                padding: 10px 20px;
                border: none;
                border-radius: 4px;
                font-size: 16px;
                cursor: pointer;
                transition: background-color 0.3s;
                align-self: flex-end; 
            }
            .filter-category, .filter-search {
                flex: 1;
                margin-right: 15px;
            }
            .filter-category label, .filter-search label {
                display: block;
                font-weight: bold;
                margin-bottom: 5px;
                color: #333;
            }
            .access-denied-container {
                margin-top: 100px;
                text-align: center;
                padding: 20px;
                border: 1px solid #dee2e6;
                background-color: #ffffff;
                border-radius: 10px;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }
            .access-denied-container h1 {
                font-size: 36px;
                margin-bottom: 10px;
                color: #dc3545;
            }
            .access-denied-container p {
                font-size: 18px;
                margin: 0;
            }
            .green-btn{
                background-color: #4CAF50;
                margin: 3px;
                border-radius: 5px;
                border: 1px;
                color: white;
            }
            .red-btn{
                background-color: crimson;
                margin: 3px;
                border-radius: 5px;
                border: 1px;
                color: white;
            }
            .header {
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                background-color: #f1f1f1;
                padding: 10px 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                z-index: 1000;
            }
            .header a {
                float: left;
                color: black;
                text-align: center;
                padding: 12px;
                margin: 10;
                text-decoration: none;
                font-size: 18px;
                line-height: 25px;
                border-radius: 4px;
                }
            .header a.logo {
                font-size: 25px;
                font-weight: bold;
            }
            .header a:hover {
                background-color: #ddd;
                color: black;
            }
            .header-right {
                float: right;
            }
            .header a.active {
                background-color: #4CAF50;
                color: white;
                font-weight: bold;
            }
            body {
                font-family: Arial, sans-serif;
                margin: 30px;
                background-color: #f9f9f9;
            }

            h1 {
                color: #333;
            }
            table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            table, th, td {
                border: 1px solid #ddd;
            }
            th, td {
                padding: 10px;
                text-align: left;
            }
            th {
                background-color: #f2f2f2;
            }
            tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            .error {
                color: red;
            }
            .centered-content-container {
                margin-top: 80px; /* Same height as the header to avoid overlap */
                flex: 1; /* Allow the content to take up remaining space */
                overflow-y: auto; /* Enable vertical scrolling */
                padding: 20px;
                justify-content: center; /* Center horizontally */
                align-items: center; /* Center vertically */
            }
            h1, h2 {
                color: #333;
            }
            .login-form {
                display: flex;
                flex-direction: column; /* Stack form elements vertically */
                align-items: center; /* Center form elements horizontally */
                width: 100%;
                max-width: 400px; /* Set a maximum width for the form */
                padding: 15px;
                background-color: #fff;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                margin: 0 auto; /* Center the form on the page horizontally */
            }
            .login-form input, .login-form button {
                display: block;
                margin: 10px 0;
                padding: 10px;
                width: 100%;
                max-width: 300px;
                border: 1px solid #ccc;
                border-radius: 4px;
                text-align: center;
            }
            .login-form input {
                text-align: left;
                width: 300px;
            }
            .login-form button {
                background-color: #4CAF50;
                color: white;
                border: none;
                cursor: pointer;
            }
            .login-form .register-btn, .product-form .back-btn {
                background-color: #9797a5b5;
            }
            .login-form .submit-btn {
                margin-bottom: 0px;
            }
            .login-form .register-btn {
                margin-top: 0px;
            }
            .login-form .submit-btn:hover {
                background-color: #45a049;
            }
            .login-form .register-btn:hover, .product-form .back-btn:hover {
                background-color: #9797a5;
            }
            .success {
                color: green;
                font-size: 14px;
                margin-bottom: 15px;
            }
            .error {
                color: red;
                font-size: 14px;
                margin-bottom: 15px;
            }
            .centered-success {
                color: green;
                font-size: 14px;
                margin-bottom: 15px;
                text-align: center;
            }
            .centered-error {
                color: red;
                font-size: 14px;
                margin-bottom: 15px;
                text-align: center;
            }
            .register-form {
                display: flex;
                flex-direction: column; /* Stack form elements vertically */
                align-items: center; /* Center form elements horizontally */
                width: 100%;
                max-width: 400px; /* Set a maximum width for the form */
                padding: 15px;
                background-color: #fff;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                margin: 100px auto; /* Center the form on the page horizontally */
            }
            .register-form input, .register-form button, select {
                display: block;
                margin: 5px 0;
                padding: 5px;
                width: 100%;
                max-width: 300px;
                border: 1px solid #ccc;
                border-radius: 4px;
                text-align: left;
            }
            .register-form input {
                text-align: left;
                width: 300px;
            }
            .register-form button {
                background-color: #4CAF50;
                color: white;
                border: none;
                cursor: pointer;
                text-align: center;
            }
            .register-form .login-btn {
                background-color: #9797a5b5;
            }
            .register-form .submit-btn:hover {
                background-color: #45a049;
            }
            .register-form .login-btn:hover {
                background-color: #9797a5;
            }
            .content-container {
                margin-top: 80px;
                flex: 1; 
                overflow-y: auto;
                padding: 20px;
            }
            .product-form form {
                margin-bottom: 20px;
                padding: 15px;
                background-color: #fff;
                border: 1px solid #ddd;
                border-radius: 5px;
                box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            }
            .product-form input, .product-form select, .product-form button {
                display: block;
                margin: 10px 0;
                padding: 10px;
                width: 100%;
                max-width: 300px;
                border: 1px solid #ccc;
                border-radius: 4px;
            }
            .product-form button {
                background-color: #4CAF50;
                color: white;
                border: none;
                cursor: pointer;
            }
            .product-form button:hover {
                background-color: #45a049;
            }
            .product-table table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            .product-table table, .product-table th, .product-table td {
                border: 1px solid #ddd;
            }
            .product-table th, .product-table td {
                padding: 10px;
                text-align: left;
            }
            .product-table th {
                background-color: #f2f2f2;
            }
            .product-table tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            .product-table img {
                max-width: 100px;
                border: 1px solid #ccc;
                border-radius: 5px;
            }
            .product-table a {
                color: #4CAF50;
                text-decoration: none;
            }
            .product-table a:hover {
                text-decoration: underline;
            }
            .order-container {
                margin: 20px auto;
                margin-top: 100px;
                padding: 20px;
                max-width: 600px;
                background-color: #fff;
                border-radius: 10px;
                box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            }
            .order-container h1 {
                text-align: center;
                color: #333;
            }
            .order-table {
                width: 100%;
                margin-bottom: 20px;
                border-collapse: collapse;
            }
            .order-table th, .order-table td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }
            .order-table th {
                background-color: #f2f2f2;
            }
            .order-form-group {
                margin-bottom: 15px;
            }
            .order-form-group label {
                display: block;
                font-weight: bold;
                margin-bottom: 5px;
            }
            .order-form-group input, .order-form-group select {
                width: 100%;
                padding: 10px;
                border: 1px solid #ddd;
                border-radius: 5px;
            }
            .order-submit-btn, .order-disabled-submit-btn {
                display: block;
                width: 100%;
                padding: 10px;
                background-color: #4CAF50;
                color: white;
                font-size: 16px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
            }
            .order-disabled-submit-btn {
                background-color: #9797a5b5;
            }
            .order-submit-btn:hover {
                background-color: #45a049;
            }
            .success-container {
                font-family: Arial, sans-serif;
                max-width: 600px;
                margin: 50px auto;
                margin-top: 100px;
                padding: 20px;
                background-color: #ffffff;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
                text-align: center;
            }
            .success-container h1 {
                color: #4CAF50;
                font-size: 32px;
                margin-bottom: 10px;
            }
            .success-container p {
                font-size: 18px;
                color: #333;
                margin-bottom: 20px;
            }
            .success-container a {
                display: inline-block;
                padding: 10px 20px;
                color: #ffffff;
                background-color: #4CAF50;
                text-decoration: none;
                border-radius: 5px;
                font-size: 16px;
            }
            .success-container a:hover {
                background-color: #45a049;
            }
            .order-id {
                color: #555;
                font-weight: bold;
            }
            .order-list-container {
                max-width: 800px;
                margin: 50px auto;
                margin-top: 100px;
                padding: 20px;
                background-color: #ffffff;
                border-radius: 10px;
                box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
            }
            .order-list-container h1 {
                font-size: 24px;
                margin-bottom: 20px;
                color: #333;
            }
            .order-list-table {
                width: 100%;
                border-collapse: collapse;
                margin-top: 20px;
            }
            .order-list-table th, .order-list-table td {
                text-align: left;
                padding: 10px;
                border: 1px solid #ddd;
            }
            .order-list-table th {
                background-color: #f2f2f2;
            }
            .order-list-table tr:nth-child(even) {
                background-color: #f9f9f9;
            }
            .order-list-table tr:hover {
                background-color: #f1f1f1;
            }
            .no-orders {
                text-align: center;
                font-size: 16px;
                color: #777;
                margin: 20px 0;
            }
            .view-order-details-btn, .order-details-btn, .order-details-back-btn {
                display: inline-block;
                padding: 10px 15px;
                background-color: #4CAF50;
                color: #fff;
                text-decoration: none;
                border-radius: 4px;
            }
            .view-order-details-btn:hover, .order-details-btn:hover, .order-details-back-btn:hover {
                background-color: #45a049;
            }
            .order-details-container {
                max-width: 800px;
                margin: 20px auto;
                margin-top: 100px;
                padding: 20px;
                background-color: #fff;
                border-radius: 8px;
                box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            .order-details-container h1 {
                text-align: center;
                color: #333;
            }
            .order-details-section {
                margin-bottom: 20px;
            }
            .order-details-section h2 {
                color: #555;
                border-bottom: 1px solid #4CAF50;
                padding-bottom: 8px;
            }
            .order-details-product-list {
                width: 100%;
                border-collapse: collapse;
                margin-top: 10px;
            }
            .order-details-product-list th, .order-details-product-list td {
                border: 1px solid #ddd;
                padding: 8px;
                text-align: left;
            }
            .order-details-product-list th {
                background-color: #f2f2f2;
            }
            .order-details-product-list td img {
                max-width: 50px;
                border-radius: 4px;
            }
            .order-details-total {
                font-size: 20px;
                font-weight: bold;
                text-align: right;
            }
            .order-status {
                font-weight: bold;
                padding: 5px 10px;
                border-radius: 5px;
            }
            .order-status.green { 
                color: #4CAF50; 
            }
            .order-status.orange {
                color: orange; 
            }
            .order-status.mocha-mousse {
                color: #a47864; 
            }
            .order-status.red { 
                color: #E64A19; 
            }
            .order-details-actions {
                position: relative;
                width: 100%;
            }
            .order-cancel-btn {
                background-color: #FF5722;
                color: #fff;
                border: none;
                border-radius: 4px;
                padding: 10px 15px;
                cursor: pointer;
                font-size: 16px;
                text-decoration: none;
                position: absolute;
                top: 10px;
                right: 10px;
            }
            .order-cancel-btn:hover {
                background-color: #E64A19;
            }
            .order-details-back-btn {
                margin-top: 10px;
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
                            w "<a href='"_adminProductManageLink_"' "_activeClass_">Product Management</a>"
                        } else {
                            w "<a href='"_adminProductManageLink_"'>Product Management</a>"
                        }

                        if requestPageName = const.#USERMANAGEPAGENAME {
                            w "<a href='"_adminUserManageLink_"' "_activeClass_">User Management</a>"
                        } else {
                            w "<a href='"_adminUserManageLink_"'>User Management</a>"
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

ClassMethod RedirectWithError(link As %String, errorMsg As %String)
{
    w "<script> window.location.href = '"_link_"?error="_errorMsg_"'; </script>"
}

ClassMethod RedirectWithSuccess(link As %String, successMsg As %String)
{
    w "<script> window.location.href = '"_link_"?success="_successMsg_"'; </script>"
}

}
