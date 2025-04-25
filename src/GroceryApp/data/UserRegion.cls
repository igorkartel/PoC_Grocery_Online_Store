Class GroceryApp.data.UserRegion Extends (%Persistent, %JSON.Adaptor)
{
    Property UserName As %String;

    Property Region As GroceryApp.data.Region;

    Index UserRegionIdx On (UserName, Region) [Unique];
}