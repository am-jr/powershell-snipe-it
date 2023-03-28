function New-SnipeAsset {
    <#
        .SYNOPSIS
            This function creates an asset on Snipe-IT
        .DESCRIPTION
           This function creates indivdual asssets. Allows custom field inserts.
        .EXAMPLE
            New-SnipeAsset -tag $assetTag -name $assetTag -status_id $status_id -model_id $model_id -purchase_date $date -customfields $customfields -SnipeApiKey $SnipeApiKey -url $url
        .LINK
            https://snipe-it.readme.io/reference/hardware-partial-update
    #>
    [CmdletBinding()]
    param (
        [parameter(mandatory = $true)]
        [string]$tag,
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
        'asset_tag'     = $tag
        'name'          = $name
        'status_id'     = $status_id
        'model_id'      = $model_id
        'purchase_date' = $Purchase_date
    }

    if ($customfields) {
        $parameters += $customfields
    }

    $body = $parameters | ConvertTo-Json

    $restArgs = @{
        'Uri'     = "$url/api/v1/hardware"
        'Headers' = $headers
        'Body'    = $body
        'Method'  = 'POST'
    }

    $response = Invoke-RestMethod @restArgs
    Return $response
}