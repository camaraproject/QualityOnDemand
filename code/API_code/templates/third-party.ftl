<#function artifactFormat p>
    <#return p.groupId + ":" + p.artifactId + ":" + p.version>
</#function>
<#function licenseFormat licenses>
    <#assign result = ""/>
    <#list licenses as license>
        <#assign result = result + license + " "/>
    </#list>
    <#return result>
</#function>
ThirdPartyNotices
-----------------
This project uses third-party software or other resources that
may be distributed under licenses different from this software.
In the event that we overlooked to list a required notice, please bring this
to our attention by contacting us via this email:
opensource@telekom.de

ThirdParty Licenses
-----------------

| Dependency | License |
| --- | --- |
<#compress>
    <#list dependencyMap as e>
        <#assign project = e.getKey() />
        <#assign license = e.getValue() />
        | ${artifactFormat(project)} | ${licenseFormat(license)} |
    </#list>
</#compress>