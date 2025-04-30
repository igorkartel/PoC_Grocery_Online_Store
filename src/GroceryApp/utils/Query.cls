Class GroceryApp.utils.Query
{
    /// Execute query
    ClassMethod ExecuteQuery(TableName As %String, FieldName As %String, FieldValue As %String, Namespace As %String) As %SQL.IResultSet
    {
        try {
            if Namespace '= "" {new $namespace zn Namespace}

            set query = "SELECT * FROM "_TableName_" WHERE "_FieldName_" = ?"
            set stmt = ##class(%SQL.Statement).%New()
            set sc = stmt.%Prepare(query)
            $$$THROWONERROR(sc)

            return stmt.%Execute(FieldValue)
        }
        catch ex {
            $$$THROWONERROR(ex.AsStatus())
        }
    }

    /// Get ID
    ClassMethod GetId(TableName As %String, FieldName As %String, FieldValue As %String, Namespace As %String = "") As %Any
    {
        set rset = ..ExecuteQuery(TableName, FieldName, FieldValue, Namespace)

        if rset && rset.%Next() {
            return rset.ID
        }

        return ""
    }
}   