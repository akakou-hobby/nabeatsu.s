#include <stdio.h>

#define MAX 1000000

/* ナベアツでボケるかを計算 */
int is_bokeru_number(int value) {
  int tmp;

  /* 3の倍数であるか */
  if (value % 3 == 0) {
    return 1;
  }

  /* 3のつく文字であるか */
  while (value != 0) {
    // value の下位1桁を tmp に代入して3かを調べる。
    tmp = value % 10;
    if (tmp == 3) {
      return 1;
    }
    // value の下位一桁を調べた後、10 で割って
    // 次のループで別の桁が取り出されるようにする
    value /= 10;
  }

  return 0;
}

int main() {
  register int count;

  /* カウントしていく */
  for (count = 1; count <= MAX; count++) {
    if (is_bokeru_number(count)) {
      // ボケる方の出力
      printf("%8d      \n", count);
    } else {
      // ボケない方の出力
      printf("%8d(BOKE)\n", count);
    }
  }
}
