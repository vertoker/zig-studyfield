#pragma once

#ifdef _WIN32
#include <windows.h>
#include <stdio.h>
#endif

void set_console_output_cp() {
#ifdef _WIN32
    printf("Activate SetConsoleOutputCP\n");
    SetConsoleOutputCP(CP_UTF8);
#endif
}