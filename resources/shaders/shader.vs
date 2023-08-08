#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aNormal;
layout (location = 2) in vec2 aTexCoords;
layout (location = 3) in vec3 aTangent;
layout (location = 4) in vec3 aBitangent;

out VS_OUT {
    vec3 FragPos;
    vec2 TexCoords;
    vec3 TangentLightPosPoint;
    vec3 TangentLightPosSpot;
    vec3 TangentLightDir;
    vec3 TangentLightDirSpot;
    vec3 TangentViewPos;
    vec3 TangentFragPos;
} vs_out;

uniform mat4 model;
uniform mat4 view;
uniform mat4 projection;

uniform vec3 lightPosPoint;
uniform vec3 lightPosSpot;
uniform vec3 viewPos;
uniform vec3 lightDir;
uniform vec3 lightDirSpot;


void main()
{
       vs_out.FragPos = vec3(model * vec4(aPos, 1.0));
       vs_out.TexCoords = aTexCoords;

       mat3 normalMatrix = transpose(inverse(mat3(model)));
       vec3 T = normalize(normalMatrix * aTangent);
       vec3 N = normalize(normalMatrix * aNormal);
       T = normalize(T - dot(T, N) * N);
       vec3 B = cross(N, T);

       mat3 TBN = transpose(mat3(T, B, N));
       vs_out.TangentLightPosPoint = TBN * lightPosPoint;
       vs_out.TangentLightPosSpot = TBN * lightPosSpot;
       vs_out.TangentLightDir = TBN * lightDir;
       vs_out.TangentLightDirSpot = TBN * lightDirSpot;
       vs_out.TangentViewPos  = TBN * viewPos;
       vs_out.TangentFragPos  = TBN * vs_out.FragPos;

       gl_Position = projection * view * model * vec4(aPos, 1.0);
}