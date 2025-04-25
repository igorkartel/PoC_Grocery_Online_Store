Class GroceryApp.utils.Seed
{

ClassMethod SeedData(className As %String, values As %String, fieldName As %String = "Name") As %Status
{
        #dim tSC As %Status = $$$OK

        try {
            for i=1:1:$LENGTH(values, ",") {
                set fieldValue = $PIECE(values, ",", i)

                // Checking if fieldValue exists
                set query = "SELECT ID FROM "_className_" WHERE "_fieldName_" = ?"
                set rset = ##class(%SQL.Statement).%ExecDirect(, query, fieldValue)

                if rset.%Next() {
                    write "Skipping existing entry: ", fieldValue, !
                    continue
                }

                // Creating a new object
                set obj = $CLASSMETHOD(className, "%New")

                if obj = "" {
                    set tSC = $$$ERROR($$$GeneralError, "Failed to create instance of class: "_className)
                }

                set $PROPERTY(obj, fieldName) = fieldValue

                $$$TOE(tSC, obj.%Save())
            }
        } catch ex {
            set tSC = ex.AsStatus()
            write "Error: ", ex.DisplayString(), !
        }

        quit tSC
}

ClassMethod SeedRegions() As %Status
{
        #dim tSC As %Status = $$$OK

        set const = ##class(GroceryApp.utils.Constants).%New()
        set regions = const.#REGIONS
        set className = const.#REGIONCLASSNAME

        set tSC = ..SeedData(className, regions)

        quit tSC
}

}
