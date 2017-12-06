#include <stdio.h>

#define MAX 100000

/* ナベアツでボケるかを計算 */
int is_bokeru_number(int value) {
  int tmp;

  // 3の倍数であるか
  if (value % 3 == 0) {
    return 1;
  }

  // 3のつく文字であるか
  while (value != 0) {
    tmp = value % 10;
    if (tmp == 3) {
      return 1;
    }
    value /= 10;
  }

  return 0;
}

int main() {
  int count;

  // カウントしていく
  for (count = 1; count <= MAX; count++) {
    if (is_bokeru_number(count)) {
      // ボケる方の出力
      printf("%d（ ＾ω＾）\n", count);
    } else {
      // ボケない方の出力
      printf("%d\n", count);
    }
  }
}
