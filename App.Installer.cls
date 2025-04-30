Class App.Installer
{
XData Install [ XMLNamespace = INSTALLER ]
{
    <Manifest>
        <Default Name="Namespace" Value="APP" />
        <Default Name="app" Value="store" />
        <If Condition='(##class(Config.Namespaces).Exists("${Namespace}")=0)'>
            <Namespace Name="${Namespace}" Create="yes" Code="${Namespace}CODE" Data="${Namespace}DATA" Ensemble="">
                <Configuration>
                    <!-- Durable data database -->
                    <Database Name="${Namespace}DATA"
                            Dir="${app}Data"
                            Create="yes"
                            MountRequired="true"
                            Resource="%DB_${Namespace}DATA"
                            PublicPermissions="RW"
                            MountAtStartup="true" />

                    <!-- Non-durable code database -->
                    <Database Name="${Namespace}CODE"
                            Dir="/code/${app}Code"
                            Create="yes"
                            MountRequired="true"
                            Resource="%DB_${Namespace}CODE"
                            PublicPermissions="RW"
                            MountAtStartup="true" />
                </Configuration>
                <CSPApplication 
                    Url="/csp/${app}" 
                    Directory="${cspdir}/${app}" 
                    AuthenticationMethods="64" 
                    MatchRoles=":%All" 
                    LoginClass="GroceryApp.pages.auth.LoginPage.cls" 
                    Grant="%All" 
                    DefaultTimeout="3600" />
            </Namespace>
        </If>
    </Manifest>
}

ClassMethod Setup(ByRef pVars, pLogLevel As %Integer = 0, pInstaller As %Installer.Installer) As %Status [ CodeMode = objectgenerator, Internal ]
{
    quit ##class(%Installer.Manifest).%Generate(%compiledclass, %code, "Install")
}

/// Change database permissions
/// <ul>
/// <li><var>dbDir</var> Path to the database.</li>
/// <li><var>mode</var> Permission mode. 0 = read/write, 1 = read-only. Optional</li>
/// </ul>
ClassMethod SetupDBPermissions(dbDir as %String, mode as %Integer = 0) As %Status {
  new $NAMESPACE
  set $NAMESPACE = "%SYS"

  set sc = $$$OK

  set db = ##class(SYS.Database).%OpenId(dbDir)
  write "Setting database permission for " _ db.Directory _ ". Setting ReadOnly from " _ db.ReadOnly _ " to " _ mode, !
  set db.ReadOnly = mode
  $$$ThrowOnError(db.%Save())

  return sc
}
}