static void ebreak(long arg0, long arg1) {
  asm volatile("addi a0, x0, %0;"
               "addi a1, x0, %1;"
               "ebreak" : : "i"(arg0), "i"(arg1));
}
static void halt(int code) { ebreak(1, code); while (1); }
int main() {
	halt(0);
	return 0;
}
