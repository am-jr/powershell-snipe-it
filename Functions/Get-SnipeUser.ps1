function Get-SnipeUser {
    <#
        .SYNOPSIS
            This function will pull users from SnipeIT
        .DESCRIPTION
           This function currently allows for searching, having no search parameters will pull all users.
        .PARAMETER deleted
            Set deleted to $True if only deleted users should be returned. Defaults to $false.
        .PARAMETER all
            Set this parameter to $true if you want both deleted and active users. Defaults to $false.
        .EXAMPLE
            Find-SnipeModel -url $url -SnipeApiKey $SnipeApiKey
        .LINK
            https://snipe-it.readme.io/reference/users
    #>

    [CmdletBinding()]
    param (
        [int]$limit,
        [string]$search,
        [string]$firstname,
        [string]$lastname,
        [string]$username,
        [string]$email,
        [string]$employee_num,
        [string]$state,
        [string]$zip,
        [string]$country,
        [int]$group_id,
        [int]$department_id,
        [int]$location_id,
        [string]$deleted = 'false', #Set this to "true" if you want to return only deleted users
        [string]$all = 'false', #Set this to "true" if you want both deleted and active users
        [parameter(mandatory = $true)]
        [SecureString]$SnipeApiKey,
        [parameter(mandatory = $true)]
        [string]$url
    )

    $SearchParameters = @{
        limit         = $limit
        search        = $search
        firstname     = $firstname
        lastname      = $lastname
        username      = $username
        email         = $email
        employee_num  = $employee_num
        state         = $state
        zip           = $zip
        country       = $country
        group_id      = $group_id
        department_id = $department_id
        location_id   = $location_id
        deleted       = $deleted
        all           = $all
    }

    #Removing all unused parameters.
    @($SearchParameters.keys) | ForEach-Object { if (-not $SearchParameters[$_]) { $SearchParameters.Remove($_) } }

    $Uri = "$url/api/v1/users"

    $HttpValueCollection = [System.Web.HttpUtility]::ParseQueryString([String]::Empty)
    foreach ($Item in $SearchParameters.GetEnumerator()) {
        if ($Item.Value.Count -gt 0) {
            $HttpValueCollection.Add($Item.Key, $Item.Value)
        }
    }

    $QueryUri = [System.UriBuilder]($Uri)
    $QueryUri.Query = $HttpValueCollection.ToString()


    $headers = @{
        'Accept'        = 'application/json'
        'Authorization' = "Bearer $([Runtime.InteropServices.Marshal]::PtrToStringAuto(
        [Runtime.InteropServices.Marshal]::SecureStringToBSTR($SnipeApiKey)))"
    }

    $restArgs = @{
        'Uri'     = "$($QueryUri.Uri.AbsoluteUri)"
        'Headers' = $headers
        'Method'  = 'GET'
    }

    $response = Invoke-RestMethod @restArgs
    return $response
}