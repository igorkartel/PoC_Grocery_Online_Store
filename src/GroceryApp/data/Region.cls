Class GroceryApp.data.Region Extends (%Persistent, %JSON.Adaptor)
{
    Property Name As %String [Required];

    Index RegionNameIndex On Name [Unique];

    Parameter DSTIME = "auto";
}