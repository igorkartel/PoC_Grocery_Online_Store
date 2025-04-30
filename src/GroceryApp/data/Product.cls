Class GroceryApp.data.Product Extends (%Persistent, %JSON.Adaptor)
{
    Property ProductID As %Integer [ Identity, Required ];

    Property Name As %String(MAXLEN = 100) [ Required ];

    Property Description As %String(MAXLEN = 10000);

    Property Image As %String(MAXLEN = 255);

    Property Price As %Float [ Required ];

    Property Category As GroceryApp.data.Category [ Required ];

    Index NameIndex On Name [ Unique ];

    Parameter DSTIME = "auto";
}