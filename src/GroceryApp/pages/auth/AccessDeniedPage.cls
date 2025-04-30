Class GroceryApp.pages.auth.AccessDeniedPage Extends GroceryApp.pages.BasePage
{

ClassMethod OnPage() As %Status
{
    do ..RenderHeaderAndApplyStyles()

    &html<
        <html>
            <head>
                <title>Access Denied</title>
            </head>
            <body>
                <div class="access-denied-container"> 
                    <h1>Access Denied</h1>
                    <p>You do not have permission to access this page.</p>
                </div>
            </body>
        </html>
    >
    
    quit $$$OK
}

}
