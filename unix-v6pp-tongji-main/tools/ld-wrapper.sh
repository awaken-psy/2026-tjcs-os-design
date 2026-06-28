#!/bin/bash
# ld wrapper: 过滤 cmake/ninja 注入的 -Wl,--dependency-file=...
# (ld 直接调用不识别 -Wl, 前缀; 该选项本意是给 gcc 驱动的)
args=()
for a in "$@"; do
    case "$a" in
        -Wl,--dependency-file=*) ;;   # 丢弃
        *) args+=("$a") ;;
    esac
done
exec /usr/bin/ld "${args[@]}"
