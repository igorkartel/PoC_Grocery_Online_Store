Class GroceryApp.data.Cart Extends (%Persistent, %JSON.Adaptor)
{
    Property UserName As %String [Required];

    Property Status As %String;

    Relationship Pchildren As GroceryApp.data.CartItem [ Cardinality = children, Inverse = Cparent ];

    Parameter DSTIME = "auto";
}