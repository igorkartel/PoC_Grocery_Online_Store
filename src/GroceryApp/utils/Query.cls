Class GroceryApp.utils.Query
{
    /// Получить ID записи по значению поля
    ClassMethod GetId(pTableName As %String, pIdField As %String, pNameValue As %String, pNamespace As %String = "APP") As %String
    {
        new $namespace
        set $namespace = pNamespace

        set id = ""

        set sql = "SELECT "_pIdField_" FROM "_pTableName_" WHERE Name = ?"

        set stmt = ##class(%SQL.Statement).%New()
        set sc = stmt.%Prepare(sql)
        if $$$ISERR(sc) {
            quit id
        }

        set rset = stmt.%Execute(pNameValue)
        if rset.%Next() {
            set id = rset.%Get(1)
        }

        quit id
    }
}