int vec1[5];
int vec2[4], vec3[7];
int var;

main()
{
    vec1[2] = 3;
    var = vec1[2] + 3;
    vec2[1] = var;
    vec3[var] = vec1[2] + vec2[1];
    printf("%d", vec1[2]);
    printf("Vector completo", vec1);
}

//@ (main)
