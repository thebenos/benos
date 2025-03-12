[bits 16]

command_ls:
    call DISK_list_files

    jmp shell_begin

command_touch:
    call DISK_create_file

    jmp shell_begin

command_rm:
    call DISK_remove_file

    jmp shell_begin