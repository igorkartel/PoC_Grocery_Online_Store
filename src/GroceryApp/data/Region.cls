Class GroceryApp.data.Region Extends (%Persistent, %JSON.Adaptor)
{
    Property Name As %String;

    Index RegionNameIndex On Name [Unique];
}