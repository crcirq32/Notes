AD uses Kerberos
    95% of fortune 1000 companies use AC && Kerberos
    abuse features, trusts, components etc.

Physical AD Components:
    Domain Controller houses everything (Top target)
    AD DS data store: Ntds.dit - contains all info in AD (%SystemRoot%\NTDS), hashes, users etc. 

Logical AD Components
    Schema - rule book/blue print. Definitions of all objects
    Domains - used to group objects in organization
        admin boundary for applying policies to groups
        replication boundary replicating data between DC
        Authentication and authorization boundary
    Tress - hierarchy of domains in AD DS
        share contiguous namespaces w/ parent domain
        may have additional child domains
        Two-way transitive trust with other domains.
    Forests - collection of trees
        share common schema
        share common config partition
        share global catalog to enable searching
        enables trust between ALL domains in forest
        share enterprise admins and schema admins group

Organizational Units (Ous) categorize objects
    Objects: /group/user/computer/shared folder/printer.
    Trusts - provide mechanism for users to gain access to resources in another domain.

Building Lab:
    Downloads: Server 2019 && windows 10 (eval)

Server: DC "Computer name - change to DC name && reboot"
    Open Server -> Manage -> "Active Directory Domain Services" -> promote to service domain
        Directory Services Restore Mode (DSRM) PW -> install