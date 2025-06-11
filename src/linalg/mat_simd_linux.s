.intel_syntax noprefix
.global mfadd_avx2
.global mfsub_avx2
.global mfmul_avx2
.global mfdiv_avx2
.section .note.GNU-stack,"",@progbits
.text

# void mfadd_avx2(float *a, float *b, float *out, unsigned int r, unsigned int c)
mfadd_avx2:
  shr r8d, 4
2:
  mov eax, r8d
1:
  vmovaps ymm0, [rdi]
  vmovaps ymm1, [rsi]
  vaddps ymm0, ymm0, ymm1
  vmovaps [rdx], ymm0

  vmovaps ymm2, [rdi + 32]
  vmovaps ymm3, [rsi + 32]
  vaddps ymm2, ymm2, ymm3
  vmovaps [rdx + 32], ymm2

  lea rdi, [rdi + 64]
  lea rsi, [rsi + 64]
  lea rdx, [rdx + 64]
  dec eax
  jnz 1b
  dec ecx
  jnz 2b
  ret

mfsub_avx2:
  shr r8d, 4
2:
  mov eax, r8d
1:
  vmovaps ymm0, [rdi]
  vmovaps ymm1, [rsi]
  vsubps ymm0, ymm0, ymm1
  vmovaps [rdx], ymm0

  vmovaps ymm2, [rdi + 32]
  vmovaps ymm3, [rsi + 32]
  vsubps ymm2, ymm2, ymm3
  vmovaps [rdx + 32], ymm2

  lea rdi, [rdi + 64]
  lea rsi, [rsi + 64]
  lea rdx, [rdx + 64]
  dec eax
  jnz 1b
  dec ecx
  jnz 2b
  ret

mfmul_avx2:
  shr r8d, 4
2:
  mov eax, r8d
1:
  vmovaps ymm0, [rdi]
  vmovaps ymm1, [rsi]
  vmulps ymm0, ymm0, ymm1
  vmovaps [rdx], ymm0

  vmovaps ymm2, [rdi + 32]
  vmovaps ymm3, [rsi + 32]
  vmulps ymm2, ymm2, ymm3
  vmovaps [rdx + 32], ymm2

  lea rdi, [rdi + 64]
  lea rsi, [rsi + 64]
  lea rdx, [rdx + 64]
  dec eax
  jnz 1b
  dec ecx
  jnz 2b
  ret

mfdiv_avx2:
  shr r8d, 4
2:
  mov eax, r8d
1:
  vmovaps ymm0, [rdi]
  vmovaps ymm1, [rsi]
  vdivps ymm0, ymm0, ymm1
  vmovaps [rdx], ymm0

  vmovaps ymm2, [rdi + 32]
  vmovaps ymm3, [rsi + 32]
  vdivps ymm2, ymm2, ymm3
  vmovaps [rdx + 32], ymm2

  lea rdi, [rdi + 64]
  lea rsi, [rsi + 64]
  lea rdx, [rdx + 64]
  dec eax
  jnz 1b
  dec ecx
  jnz 2b
  ret
