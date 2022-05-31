#include <stdio.h>

#define OK 0
#define ERR_ARGS 1
#define ERR_IO 2

void filter_positive(FILE *in, FILE *out);

/*
 * Данная программа читает бинарный файл и сохраняет все положительные числа в другой файл
 */
int main(int argc, char *argv[])
{
    int return_code = OK;
    if (argc != 3)
        return_code = ERR_ARGS;
    else
    {
        FILE *in = fopen(argv[1], "rb");
        FILE *out = fopen(argv[2], "wb");
        if (in == NULL || out == NULL)
            return_code = ERR_IO;
        else
            filter_positive(in, out);
    }

    return return_code;
}

void filter_positive(FILE *in, FILE *out)
{
    int num;
    while (fread(&num, sizeof(int), 1, in) == 1)
    {
        if (num > 0)
        {
            fwrite(&num, sizeof(int), 1, out);
        }
    }
}
