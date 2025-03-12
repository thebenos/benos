[bits 16]

%define FILE_TABLE_ENTRIES          224
%define FILE_ENTRY_SIZE             12
%define MARK_FREE_ENTRY             0x00
%define MARK_OCCUPIED_ENTRY         0x01
%define MARK_REMOVED_ENTRY          0x02

fileTable:                          times FILE_TABLE_ENTRIES * FILE_ENTRY_SIZE db MARK_FREE_ENTRY
fileCount:                          db    0