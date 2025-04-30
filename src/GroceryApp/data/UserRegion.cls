Class GroceryApp.data.UserRegion Extends (%Persistent, %JSON.Adaptor)
{
    Property UserName As %String [Required];

    Property Region As GroceryApp.data.Region [Required];

    Index UserNameIndex On UserName [IdKey, Unique];

    Parameter DSTIME = "auto";

    // TODO when Security.User is deleted - delete UserRegion as well
}