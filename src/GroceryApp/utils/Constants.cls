Class GroceryApp.utils.Constants Extends %RegisteredObject
{
// Regions
Parameter REGIONS = "EU,NA,APAC,LATAM,MEA,ANZ,SA,EE";

// Class names
Parameter REGIONCLASSNAME = "GroceryApp.data.Region";

Parameter USERREGIONCLASSNAME = "GroceryApp.data.UserRegion";

Parameter SECURITYUSERCLASSNAME = "Security.Users";

// Table names
Parameter REGIONTABLENAME = "GroceryApp_data.Region";

Parameter SECURITYUSERTABLENAME = "Security.Users";

// Page names
Parameter LOGINPAGENAME = "GroceryApp.pages.auth.LoginPage.cls";

Parameter ACCESSDENIEDPAGENAME = "GroceryApp.pages.auth.AccessDeniedPage.cls";

Parameter LOGOUTPAGENAME = "GroceryApp.pages.auth.LogoutPage.cls";

Parameter REGISTERPAGENAME = "GroceryApp.pages.auth.RegisterPage.cls";

Parameter PRODUCTLISTPAGENAME = "#";

Parameter ORDERLISTPAGENAME = "#";

Parameter USERMANAGEPAGENAME = "#";

Parameter MANAGEPRODUCTPAGENAME = "#";

Parameter CARTPAGENAME = "#";

// Error/Success messages
Parameter REGISTRATIONSUCCESS = "Registration_is_successful.";

Parameter REGISTRATIONFAILED = "Registration_failed._Please_try_again.";

Parameter LOGINFAILERROR = "Login_failed._Please_try_again.";

Parameter REQUIREDFIELDSERROR = "Missing_fields.";

Parameter LOGOUTSUCCESS = "Logout_is_successful.";

Parameter INVALIDREGIONERROR = "Invalid_region_selected._Please_try_again.";

Parameter USEREXISTSERROR = "User_with_this_email_already_exists.";

Parameter MISSINGFIELDSERROR = "Missing_Login_or_Password_fields.";

}
