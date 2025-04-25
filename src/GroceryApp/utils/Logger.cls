Class GroceryApp.utils.Logger
{
    /// Логгирование отладочного сообщения
    ClassMethod LogDebug(message As %String)
    {
        Set timestamp = $ZDATETIME($HOROLOG, 3, 1)
        Set ^GroceryAppLogs("Debug", $INCREMENT(^GroceryAppLogs("Index"))) = timestamp_" - "_message
    }

    /// Показать все логи
    ClassMethod DisplayLogs()
    {
        ZWRITE ^GroceryAppLogs
    }
}