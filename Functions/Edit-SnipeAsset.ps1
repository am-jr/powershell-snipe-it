function Edit-SnipeAsset {
    <#
        .SYNOPSIS
            This function updates an asset on Snipe-IT
        .DESCRIPTION
           This function allows for partial update on indivdual asssets. Currently does not accept all updatable fields.
        .EXAMPLE
            Edit-SnipeAsset -id $id -name $assetTag -status_id $status_id -model_id $model_id -purchase_date $date -customfields $customfields -SnipeApiKey $SnipeApiKey -url $url
        .LINK
            https://snipe-it.readme.io/reference/hardware-partial-update
    #>
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true)]
        [string]$id,
        [parameter(mandatory = $true)]
        [string]$Name,
        [parameter(mandatory = $true)]
        [int]$Status_id,
        [parameter(mandatory = $true)]
        [int]$Model_id,
        [datetime]$Purchase_date,
        [hashtable] $customfields,
        [parameter(mandatory = $true)]
        [securestring]$SnipeApiKey,
        [parameter(mandatory = $true)]
        [string]$url
    )

    $headers = @{
        'Accept'        = 'application/json'
        'Authorization' = "Bearer $([Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SnipeApiKey)))"
        'Content-Type'  = 'application/json'
    }

    $parameters = @{
        'name'      = $Name
        'model_id'  = $Model_id
        'status_id' = $Status_id
    }

    if ($customfields) {
        $parameters += $customfields
    }

    $Body = $parameters | ConvertTo-Json;

    $restArgs = @{
        'Uri'     = "$url/api/v1/hardware/$id"
        'Headers' = $headers
        'Body'    = $body
        'Method'  = 'PATCH'
    }

    $response = Invoke-RestMethod @restArgs
    Return $response
}