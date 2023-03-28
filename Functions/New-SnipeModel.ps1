function New-SnipeModel {
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true)]
        [string]$name,
        [string]$model_number,
        [parameter(mandatory = $true)]
        [int]$category_id,
        [parameter(mandatory = $true)]
        [int]$manufacturer_id,
        [int]$fieldset_id,
        [parameter(mandatory = $true)]
        [securestring]$SnipeApiKey,
        [parameter(mandatory = $true)]
        [string]$url
    )

    $headers = @{
        'Accept'        = 'application/json'
        'Authorization' = "Bearer $([Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SnipeApiKey)))"
    }

    $body = @{
        'name'            = "$name"
        'model_number'    = "$model_number"
        'manufacturer_id' = $Manufacturer
        'category_id'     = $category_id
        'fieldset_id'     = $fieldset_id
    }

    $restArgs = @{
        'Uri'     = "$url/api/v1/models"
        'Headers' = $headers
        'Body'    = $body
        'Method'  = 'POST'
    }

    Invoke-RestMethod @restArgs
}