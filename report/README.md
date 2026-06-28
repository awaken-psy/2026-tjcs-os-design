# 操作系统课程设计报告 —— UNIX V6++ 离散化内存管理

参照学长报告（白佳煜, 2352733）结构搭建的 LaTeX 全文架构。

## 目录结构

```
report/
├── main.tex              主控文件 (文档类 / 宏包 / 封面 / 目录 / 章节引入)
├── latexmkrc             latexmk 编译配置 (xelatex)
├── refs.bib              参考文献 BibTeX 库 (备用, 当前用手写条目)
├── chapters/
│   ├── cover.tex         封面
│   ├── abstract.tex      摘要
│   ├── references.tex    参考文献
│   ├── ch01_intro.tex    第一章  绪论
│   ├── ch02_requirement.tex  第二章  需求分析与总体思路
│   ├── ch03_pagetable.tex    第三章  页表系统改造
│   ├── ch04_allocator.tex    第四章  物理页框分配方式改造
│   ├── ch05_image.tex        第五章  离散化进程映像管理
│   ├── ch06_env.tex          第六章  本地运行环境与工程适配
│   ├── ch07_debug.tex        第七章  关键问题与调试过程
│   ├── ch08_test.tex         第八章  系统测试与验证   ← 运行截图放这里
│   ├── ch09_eval.tex         第九章  设计评价与不足
│   └── ch10_conclusion.tex   第十章  总结与体会
└── figures/              插图与运行截图 (logo.png, run_*.png ...)
```

## 编译

需要 TeX 发行版 (TeX Live / MiKTeX) 带 `ctex` + `xelatex`。本机已具备。

```bash
cd report
latexmk            # 推荐: 自动多遍编译 + 清理
# 或
xelatex main.tex && xelatex main.tex   # 手动两遍 (生成目录/交叉引用)
```

清理中间文件: `latexmk -c` ；彻底清理: `latexmk -C`。

## 填写指引

1. **封面信息**: 编辑 `main.tex` 顶部的 `\newcommand`（姓名 / 学号 / 小组 / 日期），
   以及 `chapters/cover.tex`（学院、专业、指导教师）。校徽放 `figures/logo.png`。
2. **正文**: 每个章节文件里，`% TODO` 注释是该节要覆盖的要点（已结合源码给出函数名、
   地址、行号线索）。把要点展开成正文，删掉 TODO 即可。
3. **代码清单**: 用 `lstlisting` 环境，参见 `ch03_pagetable.tex` 中的示例；
   代码清单自动按章编号（代码清单 3.1）。引用大段源码可用 `\lstinputlisting`。
4. **图 / 表**: 自动按章编号（图 3-1 / 表 4-1），第八章已留运行截图占位，
   把截图放入 `figures/` 后取消注释对应 `\includegraphics`。
5. **页眉 / 字体 / 编号风格**: 均在 `main.tex` 集中配置，按需调整。

## 交付物对应

- **报告**: 本 LaTeX 工程 → 编译出 PDF
- **运行截图**: 放入 `figures/`，在第八章引用
- **源码**: 即仓库 `docs/src_V5/`
