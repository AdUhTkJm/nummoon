.intel_syntax noprefix
.global vfadd_avx2
.global vfsub_avx2
.global vfmul_avx2
.global vfdiv_avx2
.global vfaddf_avx2
.global vfsubf_avx2
.global vfmulf_avx2
.global vfdivf_avx2
.global vflinspace_avx2
.section .note.GNU-stack,"",@progbits
.text

# Only available on Linux, with System-V ABI.
# Arguments are rdi, rsi, rdx, rcx, r8, r9 for the first 6 integers.
# Callee-saved registers only include rbx, rbp, rsp, r12-r15. No other things are needed.

# void vfadd_avx2(float *a, float *b, float *out, unsigned size)
vfadd_avx2:
  shr ecx, 4
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
  dec ecx
  jne 1b
  ret

# void vfsub_avx2(float *a, float *b, float *out, unsigned size)
vfsub_avx2:
  shr ecx, 4
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
  dec ecx
  jne 1b
  ret

# void vfmul_avx2(float *a, float *b, float *out, unsigned size)
vfmul_avx2:
  shr ecx, 4
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
  dec ecx
  jne 1b
  ret

# void vfdiv_avx2(float *a, float *b, float *out, unsigned size)
vfdiv_avx2:
  shr ecx, 4
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
  dec ecx
  jne 1b
  ret

# void vfaddf_avx2(float *a, float b, float *out, unsigned size)
vfaddf_avx2:
  shr edx, 4
  vbroadcastss ymm1, xmm0
1:
  vmovaps ymm0, [rdi]
  vaddps ymm0, ymm0, ymm1
  vmovaps [rsi], ymm0

  vmovaps ymm2, [rdi + 32]
  vaddps ymm2, ymm2, ymm1
  vmovaps [rsi + 32], ymm2

  lea rdi, [rdi + 64]
  lea rsi, [rsi + 64]
  dec edx
  jne 1b
  ret

# void vfsubf_avx2(float *a, float b, float *out, unsigned size)
vfsubf_avx2:
  shr edx, 4
  vbroadcastss ymm1, xmm0
1:
  vmovaps ymm0, [rdi]
  vsubps ymm0, ymm0, ymm1
  vmovaps [rsi], ymm0

  vmovaps ymm2, [rdi + 32]
  vsubps ymm2, ymm2, ymm1
  vmovaps [rsi + 32], ymm2

  lea rdi, [rdi + 64]
  lea rsi, [rsi + 64]
  dec edx
  jne 1b
  ret

# void vfmulf_avx2(float *a, float b, float *out, unsigned size)
vfmulf_avx2:
  shr edx, 4
  vbroadcastss ymm1, xmm0
1:
  vmovaps ymm0, [rdi]
  vmulps ymm0, ymm0, ymm1
  vmovaps [rsi], ymm0

  vmovaps ymm2, [rdi + 32]
  vmulps ymm2, ymm2, ymm1
  vmovaps [rsi + 32], ymm2

  lea rdi, [rdi + 64]
  lea rsi, [rsi + 64]
  dec edx
  jne 1b
  ret

# void vfdivf_avx2(float *a, float b, float *out, unsigned size)
vfdivf_avx2:
  shr edx, 4
  vbroadcastss ymm1, xmm0
1:
  vmovaps ymm0, [rdi]
  vdivps ymm0, ymm0, ymm1
  vmovaps [rsi], ymm0

  vmovaps ymm2, [rdi + 32]
  vdivps ymm2, ymm2, ymm1
  vmovaps [rsi + 32], ymm2

  lea rdi, [rdi + 64]
  lea rsi, [rsi + 64]
  dec edx
  jne 1b
  ret

# void vflinspace_avx2(float *out, float start, float step, unsigned size);
vflinspace_avx2:
  # Prepare 8 increasing elements and starting vector
  vmovaps ymm2, [rip + vf_index_increase_8]
  vbroadcastss ymm3, xmm1
  vmulps ymm2, ymm2, ymm3
  vbroadcastss ymm0, xmm0
  vaddps ymm2, ymm2, ymm0

  # Calculate step for 8 elements
  vmulss xmm1, xmm1, [rip + float_8]
  vbroadcastss ymm1, xmm1

  xor rax, rax
1:
  vmovaps [rdi + 4 * rax], ymm2
  vaddps ymm2, ymm2, ymm1

  vmovaps [rdi + 4 * rax + 32], ymm2
  vaddps ymm2, ymm2, ymm1

  add eax, 16
  cmp eax, esi
  jb 1b
  ret

.section .rodata
.align 32
vf_index_increase_8:
  .float 0, 1, 2, 3, 4, 5, 6, 7
float_8:
  .float 8
