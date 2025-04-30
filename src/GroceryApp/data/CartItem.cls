Class GroceryApp.data.CartItem Extends (%Persistent, %JSON.Adaptor)
{
    Property Product As GroceryApp.data.Product [ Required ];

    Property Quantity As %Integer [ Required ];

    Property SubTotal As %Float [ Calculated, SqlComputeCode = {
        set productObj = ##class(GroceryApp.data.Product).%OpenId({Product})
        set {SubTotal} = $Select($IsObject(productObj): (productObj.Price * {Quantity}), 0:0)
    }, SqlComputed ];

    Relationship Cparent As GroceryApp.data.Cart [ Cardinality = parent, Inverse = Pchildren ];

    Parameter DSTIME = "auto";
}