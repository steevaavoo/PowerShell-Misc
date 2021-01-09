# Add custom folders to all subfolders

# In $ParentFolder, specify the parent folder _containing_ the subfolders _into_ which the custom folders will be
# injected.

# For example, if custom folders are going into every folder directly _under_ C:\ParentFolder
# i.e. C:\ParentFolder\Subfolder1 <- injecting custom folders under here to create a structure thusly:
# C:\ParentFolder\Subfolder1\CustomInjectedFolder1
# C:\ParentFolder\Subfolder1\CustomInjectedFolder2
# C:\ParentFolder\Subfolder1\CustomInjectedFolder3
# C:\ParentFolder\Subfolder2\CustomInjectedFolder1
# C:\ParentFolder\Subfolder2\CustomInjectedFolder2
# C:\ParentFolder\Subfolder2\CustomInjectedFolder3
# You would specify "C:\ParentFolder"
$ParentFolder = "D:\TestParentFolder"

# List of custom folders to inject
$InjectFolders = "TEST1","TEST2","TEST3"

# Get all the subfolders, one level down, into a variable
$Folders = Get-ChildItem -Path $ParentFolder -Directory -Depth 0

foreach ( $folder in $Folders ) {
    foreach ($InjectFolder in $InjectFolders) {
    New-Item -Path $($folder.FullName) -Name $InjectFolder -ItemType Directory
    }
}
