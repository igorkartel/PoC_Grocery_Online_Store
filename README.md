### Usage examples:
* Management Portal http://localhost:52773/csp/sys/UtilHome.csp
* Application login page http://localhost:52773/csp/store/GroceryApp.pages.auth.LoginPage.cls

### Contribution guidelines ###
* Code review
* Nice to have (Writing tests)

### Durable storage config:
* To provide durable storage on host create /external/durable dir on local env:
    - mkdir -p ${PATH_TO_PROJECT}/external/durable
* Provide permissions to write to storage to container user: 
    - sudo chown 51773:51773 ${PATH_TO_PROJECT}/external/durable
* In your `.env` file update `PATH_TO_PROJECT` to reflect actual path to the project.

#### Additional Notes for Windows (WSL)
To modify file owners and permissions in WSL, you need to enable metadata support. Perform the following steps:

1\. Edit or create the /etc/wsl.conf file inside the WSL shell (you may need sudo for this):

```
[automount]
options = "metadata"
```
Save the file.

2\. Restart your computer for the changes to take effect.

### Install guide:
* docker compose up -d --build

### Predefined users:
* Management Portal admin user:
    * username: _SYSTEM
    * password: SYS
* Application admin user:
    * email: customsuperuser@admin.com
    * password: password
    
### Class Compilation
* For local development convenience:
To change and compile classes in the code database after the container has started, you have two options:

    1. IRIS Terminal:

        ZN "%SYS"
        Do ##class(App.Installer).SetupDBPermissions("/code/storeCode/", 0)

        This command sets the code database at /code/storeCode/ to read-write mode (1 = read-only, 0 = read/write).

    2. Management Portal:

        1. Navigate to System > Configuration > Local Databases.
        2. Select the APPCODE database.
        3. Uncheck the Mount Read-Only box.
        4. Save the changes.

        These steps allow you to toggle the code database between read/write and read-only states as needed for development.
