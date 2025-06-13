.intel_syntax noprefix
.global mfadd_avx2
.global mfsub_avx2
.global mfmul_avx2
.global mfdiv_avx2
.global mfmmul_avx2
.section .note.GNU-stack,"",@progbits
.text

# void mfadd_avx2(float *a, float *b, float *out, unsigned r, unsigned c)
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

# void mfsub_avx2(float *a, float *b, float *out, unsigned r, unsigned c)
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

# void mfmul_avx2(float *a, float *b, float *out, unsigned r, unsigned c)
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

# void mfdiv_avx2(float *a, float *b, float *out, unsigned r, unsigned c)
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

# void mfmmul_avx2(float *a, float *b, float *out, unsigned n, unsigned m, unsigned k)
# a: N * M; b: M * K; c: N * K
# N = ecx, M = r8d, K = r9d
# K is rounded to multiple of 16, but N and M are not.

# Operation:
# for k = 0..M
#   for i = 0..N
#     for j = 0..K step 8
#       C[i][j..j+7] += A[i][k] * B[k][j..j+7]
mfmmul_avx2:
  push rbp
  mov rbp, rsp
  push r12
  push r13

  # Round M up to 16.
  mov r13d, r8d
  add r13d, 15
  and r13d, -16
  xor rax, rax    # k
3:
  cmp eax, r8d
  jge 3f

  xor r10, r10    # i
2:
  cmp r10d, ecx
  jge 2f

  xor r11, r11    # j

  # Find A[i][k], whose address is (A + 4 * (i * M + k))
  # But the M needs to be rounded
  mov r12d, r10d
  imul r12d, r13d
  add r12d, eax
  vmovss xmm0, [rdi + 4 * r12]
  vbroadcastss ymm0, xmm0

  # Find C[i]; address is (C + 4 * i * K)
  mov r12d, r10d
  imul r12d, r9d
  lea r12, [rdx + 4 * r12]
1:
  cmp r11d, r9d
  jge 1f

  # C[i][j..j+7] += A[i][k] * B[k][j..j+7]
  vmovaps ymm1, [rsi + 4 * r11]
  vmulps ymm1, ymm1, ymm0
  vmovaps ymm2, [r12 + 4 * r11]
  vaddps ymm1, ymm1, ymm2
  vmovaps [r12 + 4 * r11], ymm1

  add r11d, 8
  jmp 1b
1:
  inc r10d
  jmp 2b
2:
  # Find B[k] by iteratively adding 4 * K to B
  lea rsi, [rsi + 4 * r9]
  inc eax
  jmp 3b
3:
  pop r12
  mov rsp, rbp
  pop rbp
  ret
