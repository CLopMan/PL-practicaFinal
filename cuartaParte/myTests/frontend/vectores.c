int vec1[5];
int vec2[4], vec3[7];

main()
{
    vec1[2] = 3;
    vec2[1] = vec1[2] + 5;
    vec3[4] = vec1[2] + vec2[1];
    printf("%d", vec1[2]);
    printf("Vector completo", vec1);
}

//@ (main)
