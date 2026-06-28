<!-- Slide number: 1 -->

UNIX V6 ++ 离散化
1

<!-- Slide number: 2 -->
# 内存管理方式
设计目标：将UNIX V6++的内存管理修改为离散化管理方式，不使用盘交换区
（1）修改UNIX V6++的页表系统
（2）将内存分配方式改为位示图
（3）离散化存储
2

<!-- Slide number: 3 -->
# 需要完成的设计内容
页表系统修改
3

<!-- Slide number: 4 -->
# 页表系统

代码段
数据段

堆栈段

保留区
内核
内核堆对象
页表区
PPDA
4M+4K
8M-1
3G
3G+4M-1
3G+1M
3G+1.5M
3G+2M
0
保留区

1M
内核
1.5M
内核堆对象
2M
页表区
4M
用户区
代码段

PPDA
数据段
堆栈段
x_caddr
p_addr

![](图片58.jpg)
三张页表保存在哪里？
页表的构成
页目录保存在哪里？

![](图片59.jpg)
4

<!-- Slide number: 5 -->
# 页表系统

代码段
数据段

堆栈段

保留区
内核
内核堆对象
页表区
PPDA
4M+4K
8M-1
3G
3G+4M-1
3G+1M
3G+1.5M
3G+2M

0x201号页框
Page Table 768#
现运行进程的内核页表与用户页表
0x202号页框
Page Table 0#
0x203号页框
Page Table 1#
……
……

0x200号页框
0
保留区

1M
内核
1.5M
内核堆对象
2M
页表区
4M
用户区
0x200000
CR3
Page Directory
页表的构成
Page Directory（0x200号页框）
| Page Base Address |  | s/u | r/w | p |
| --- | --- | --- | --- | --- |
| 0x202 |  | 1 | 1 | 1 |
| 0x203 |  | 1 | 1 | 1 |
| …… |  |  |  |  |
| 0x201 |  | 0 | 1 | 1 |
| …… |  |  |  |  |
0#

1#
768#
5

<!-- Slide number: 6 -->
# 页表系统

代码段
数据段

堆栈段

保留区
内核
内核堆对象
页表区
PPDA
4M+4K
8M-1
3G
3G+4M-1
3G+1M
3G+1.5M
3G+2M

0x201号页框
Page Table 768#
现运行进程的内核页表与用户页表
0x202号页框
Page Table 0#
0x203号页框
Page Table 1#
……
……

0x200号页框
0
保留区

1M
内核
1.5M
内核堆对象
2M
页表区
4M
用户区
0x200000
CR3
Page Directory
占用两个连续页框
所有进程的……
页表的构成
相对虚实地址映射表
|  | Page Base Addr |  | s/u | r/w | p |
| --- | --- | --- | --- | --- | --- |
| 0# | xxx |  | x | x | x |
|  | … |  | … | … | … |
| 1024# | xxx |  | x | x | x |
| 1025# | 0 |  | 1 | 0 | 1 |
| 1026# | 1 |  | 1 | 0 | 1 |
| 1027# | 1 |  | 1 | 1 | 1 |
|  | 2 |  | 1 | 1 | 1 |
|  | 全0 |  |  |  |  |
|  | 3 |  | 1 | 1 | 1 |
0
用户区
代码段

PPDA
数据段
堆栈段
0
假设装入

6

<!-- Slide number: 7 -->
# 页表系统

代码段
数据段

堆栈段

保留区
内核
内核堆对象
页表区
PPDA
4M+4K
8M-1
3G
3G+4M-1
3G+1M
3G+1.5M
3G+2M
0
保留区

1M
内核
1.5M
内核堆对象
2M
页表区
4M
用户区
虚实地址空间的分布沿用UNIX V6++的设计
修改要求：
（1）不使用交换区；
（2）直接使用相对表作为进程的物理页表
相对虚实地址映射表
页表的构成
|  | Page Base Addr |  | s/u | r/w | p |
| --- | --- | --- | --- | --- | --- |
| 0# | xxx |  | x | x | x |
|  | … |  | … | … | … |
| 1024# | xxx |  | x | x | x |
| 1025# | 0 |  | 1 | 0 | 1 |
| 1026# | 1 |  | 1 | 0 | 1 |
| 1027# | 1 |  | 1 | 1 | 1 |
|  | 2 |  | 1 | 1 | 1 |
|  | 全0 |  |  |  |  |
| 2023# | 3 |  | 1 | 1 | 1 |

②. if r/w==0，直接用x_caddr计算并写入

③. if r/w==1，直接用p_addr计算并写入
7

<!-- Slide number: 8 -->
# 页表系统

代码段
数据段

堆栈段

保留区
内核
内核堆对象
页表区
PPDA
4M+4K
8M-1
3G
3G+4M-1
3G+1M
3G+1.5M
3G+2M
0
保留区

1M
内核
1.5M
内核堆对象
2M
页表区
4M
用户区
虚实地址空间的分布沿用UNIX V6++的设计
修改要求：
（1）不使用交换区；
（2）直接使用相对表作为进程的物理页表

（3）每个进程的页目录不同
相对虚实地址映射表
页表的构成
|  | Page Base Addr |  | s/u | r/w | p |
| --- | --- | --- | --- | --- | --- |
| 0# | xxx |  | x | x | x |
|  | … |  | … | … | … |
| 1024# | xxx |  | x | x | x |
| 1025# | 0 |  | 1 | 0 | 1 |
| 1026# | 1 |  | 1 | 0 | 1 |
| 1027# | 1 |  | 1 | 1 | 1 |
|  | 2 |  | 1 | 1 | 1 |
|  | 全0 |  |  |  |  |
| 2023# | 3 |  | 1 | 1 | 1 |

②. if r/w==0，直接用x_caddr计算并写入

③. if r/w==1，直接用p_addr计算并写入
8

<!-- Slide number: 9 -->
# 页表系统

代码段
数据段

堆栈段

保留区
内核
内核堆对象
页表区
PPDA
4M+4K
8M-1
3G
3G+4M-1
3G+1M
3G+1.5M
3G+2M

0
保留区

1M
内核
1.5M
内核堆对象
2M
页表区
4M
用户区
Page Table 768#
0x200号页框
0x201号页框
Page Table 0#
所有进程的核心页表和0#用户页表
Page Directory

0#进程的页
目录和1#用户页表
Page Table 1#

Page Directory
每个进程自己的页目录和1#用户页表
页表的构成
Page Table 1#
Page Directory
Page Table 1#
。。。。。。
（3）每个进程的页目录不同
9

<!-- Slide number: 10 -->
# 页表系统

代码段
数据段

堆栈段

保留区
内核
内核堆对象
页表区
PPDA
4M+4K
8M-1
3G
3G+4M-1
3G+1M
3G+1.5M
3G+2M

0
保留区

1M
内核
1.5M
内核堆对象
2M
页表区
4M
用户区
？？？
CR3
Page Table 768#
0x200号页框
0x201号页框
Page Table 0#
所有进程的核心页表和0#用户页表
Page Directory

0#进程的页
目录和1#用户页表
Page Table 1#

Page Directory
每个进程自己的页目录和1#用户页表
页表的构成
Page Table 1#
Page Directory
进程创建时动态分配，写入CR3
Page Table 1#
。。。。。。
| Page Base Address |  | s/u | r/w | p |
| --- | --- | --- | --- | --- |
| 0x201 |  | 1 | 1 | 1 |
| ??? |  | 1 | 1 | 1 |
| …… |  |  |  |  |
| 0x200 |  | 0 | 1 | 1 |
| …… |  |  |  |  |
进程创建时动态分配，登记入页目录
（3）每个进程的页目录不同
10

<!-- Slide number: 11 -->
# 页表系统

代码段
数据段

堆栈段

保留区
内核
内核堆对象
页表区
PPDA
4M+4K
8M-1
3G
3G+4M-1
3G+1M
3G+1.5M
3G+2M

0
保留区

1M
内核
1.5M
内核堆对象
2M
页表区
4M
用户区
Page Table 768#
0x200号页框
0x201号页框
Page Table 0#
所有进程的核心页表和0#用户页表
Page Directory

0#进程的页
目录和1#用户页表
Page Table 1#

Page Directory
每个进程自己的页目录和1#用户页表
页表的构成
Page Table 1#
Page Directory
Page Table 1#
。。。。。。
#define FlushPageDirectory()    \
    __asm__ __volatile__(" movl %0, %%cr3" : : "r"(0x200000) );

#define FlushPageDirectory(pgTable) \
    __asm__ __volatile__(" movl %0, %%cr3" : : "r"(pgTable));

（3）每个进程的页目录不同
11

<!-- Slide number: 12 -->
# 页表系统
0
4M

proc表
0x200号页框
代码段

Page Table 768#
p_addr
p_textp
proc[i]
0x201号页框
Page Table 0#
p_PageDirectory
user对象
核心栈
数据段
用户栈
进程pa的可交换部分
页表的构成

u_MemoryDescriptor
m_UserPageTableArray;
m_TextStartAddress;
m_TextSize;
m_DataStartAddress;
m_DataSize;
m_StackSize;

text表
x_daddr
x_caddr
……
x_count = 1
x_ccount = 1
text[j]
（4）进程图像的需要修改
登记页目录的起始虚地址
页表区
页目录
1#页表
登记1#页表的起始虚地址
4M
12

<!-- Slide number: 13 -->
# 页表系统
（5）对Process类的修改
在Process类中增加：
public:
    PageDirectory *p_PageDirectory;             /* 指向每个进程页目录的起始逻辑地址 */
    unsigned long GetPageDirectoryPhyAddr();
页表的构成
unsigned long Process::GetPageDirectoryPhyAddr()
{
    return (unsigned long)(this->p_PageDirectory) - Machine::KERNEL_SPACE_START_ADDRESS;
}

指向进程页目录的逻辑地址              –             3G

<!-- Slide number: 14 -->
# 页表系统
（6）对MemoryDescriptor的修改
需要修改的接口函数：
| class MemoryDescriptor |
| --- |
| /\* 申请并初始化PageDirectory，在做Map操作前使用 \*/ + void Initialize(); /\* 在释放进程时，需要调用该操作释放被占用的页表 \*/ + void Release(); + void ClearUserPageTable(); + PageTable\* GetUserPageTableArray(); + unsigned long GetTextStartAddress(); + unsigned long GetTextSize(); + unsigned long GetDataStartAddress(); + unsigned long GetDataSize(); + unsigned long GetStackSize(); + void MapTextEntrys(…); + void MapDataEntrys(…); + void MapStackEntrys(…); + unsigned int MapEntry(…); + bool EstablishUserPageTable(…); //修改MapToPageTable()函数将1#用户页表页框号写到私有的页目录 + void MapToPageTable(); |

因为m_UserPageTableArray只是指向一个页的用户页表，所以初始化时只分配一个页，回收时只回收一个页，清除时也只需要清除一个页
页表的构成

这些与相对表设置物理页表相关的接口函数都不再需要
需要新增的接口函数：
调用FlushPageDirectory函数将页目录的物理页框号写入CR3寄存器

14

<!-- Slide number: 15 -->
# 页表系统
（7）修改进程生命周期中所有与分页机制相关的操作
NewProc（）

1
2
创建进程时：
esp, ebp -> u.u_rsav

需要修改
为子进程申请复制虚页表
页表的构成
Newproc()

内存分配成功？

子进程复制父进程图象
子p_addr指向该内存
不需要考虑内存不够的情况！！！
返回(0)
return 0
15

<!-- Slide number: 16 -->
# 页表系统
（7）修改进程生命周期中所有与分页机制相关的操作
创建进程时：
PageDirectory *AllocPageDirectory();

void InitProcPageDirectory(Process *proc, PageTable * privateUsrPageTable);
| Page Base Address |  | s/u | r/w | p |
| --- | --- | --- | --- | --- |
|  |  |  |  |  |
|  |  |  |  |  |
| …… |  |  |  |  |
|  |  |  |  |  |
| …… |  |  |  |  |
p_PageDirectory
为进程分配一张页目录
页表的构成

1#页表的逻辑地址
| Page Base Address |  | s/u | r/w | p |
| --- | --- | --- | --- | --- |
| 0x201 |  | 1 | 1 | 1 |
| ??? |  | 1 | 1 | 1 |
| …… |  |  |  |  |
| 0x200 |  | 0 | 1 | 1 |
| …… |  |  |  |  |
转成物理地址
16

<!-- Slide number: 17 -->
# 页表系统
（7）修改进程生命周期中所有与分页机制相关的操作
进程切换时：
#define SwtchUStruct(p) \
    Machine::Instance().GetKernelPageTable().m_Entrys[Kernel::USER_PAGE_INDEX].m_PageBaseAddress \
        = (p)->p_addr / PageManager::PAGE_SIZE; \
    FlushPageDirectory();
页表的构成

#define SwtchUStruct(p)                                                                           \
    Machine::Instance().GetKernelPageTable().m_Entrys[Kernel::USER_PAGE_INDEX].m_PageBaseAddress = (p)->p_addr >> 12; \
    FlushPageDirectory((p)->GetPageDirectoryPhyAddr());

17

<!-- Slide number: 18 -->
# 页表系统
（7）修改进程生命周期中所有与分页机制相关的操作
void ProcessManager::SetupProcessZero()
{
   需要在最后添加：将0#进程的页目录设置在4M开始的第一个物理页框
}
页表的构成
18

<!-- Slide number: 19 -->
# 需要完成的设计内容
将内存分配方式改为位示图
19

<!-- Slide number: 20 -->
# 存储空间管理
|  | 起始地址/KB | 大小/KB |
| --- | --- | --- |
| 1 | 20 | 10 |
| 2 | 32 | 15 |
| 3 | 50 | 20 |
最多包含512个表项的空闲分区表
public:MapNode map[512];
struct MapNode
{
    unsigned long m_Size;
    unsigned long m_AddressIdx;
};
其中每一个表项包含空闲分区的大小和分区的起始地址
用分区表管理内存
20

<!-- Slide number: 21 -->
# 存储空间管理
0
保留区域

1M
内核
1.5M
内核堆对象
2M
页表区
4M
用户区
内核对象区、页表区、用户区均采用可变分区方式进行分配，
分别由三张空闲分区表管理：
最多包含512个表项的空闲分区表
public:MapNode map[512];
struct MapNode
{
    unsigned long m_Size;
    unsigned long m_AddressIdx;
};
| 大小 | 起始地址 |
| --- | --- |
| 0.5M | 1.5M |
其中每一个表项包含空闲分区的大小和分区的起始地址
| 大小 | 起始地址 |
| --- | --- |
| 2M-16K | 2M+16K |
用分区表管理内存
内核堆对象区，其map初始化为：
map[0]. m_AddressIdx = 1.5M，map[0]. m_Size = 0.5M。

负责管理页表区，其map初始化为：
map[0]. m_AddressIdx = 2M+16K，即：从204号页框开始。 map[0]. m_Size = 2M-16K，即：剩余的页表区。

用户区，其map初始化为：
map[0]. m_AddressIdx = 4M，大小至整个物理内存。
| 大小 | 起始地址 |
| --- | --- |
| 至整个物理内存 | 4M |
21

<!-- Slide number: 22 -->
# 存储空间管理

<MapNode.h>
|  | 起始地址/KB | 大小/KB |
| --- | --- | --- |
| 1 | 20 | 10 |
| 2 | 32 | 15 |
| 3 | 50 | 20 |
| struct MapNode |
| --- |
| + unsigned long m\_Size; + unsigned long m\_AddressIdx; |
用位示图管理内存

<Allocator.h>
<Allocator.cpp>
| class Allocator |
| --- |
| - static Allocator m\_Instance; |
| + unsigned long Alloc(MapNode map[], unsigned long size); + unsigned long Free(MapNode map[], unsigned long size, unsigned long addrIdx); + static Allocator& GetInstance(); |

22

<!-- Slide number: 23 -->
# 存储空间管理

<MapNode.h>
|  | 起始地址/KB | 大小/KB |
| --- | --- | --- |
| 1 | 20 | 10 |
| 2 | 32 | 15 |
| 3 | 50 | 20 |
| struct MapNode |
| --- |
| + unsigned long m\_Size; + unsigned long m\_AddressIdx; |
| class BitMap |
| --- |
| + unsigned long m\_AddressIdx; + int rows; + unsigned long long int map[256]; |
| + void set(unsigned long startAddr, unsigned long page\_num) |
用位示图管理内存

<Allocator.h>
<Allocator.cpp>
64位无符号长整型
……..

……..

rows
……..
……..
……..
……..

每个bit对应一个物理页框，4096字节；0表示空闲，1表示已分配
| class Allocator |
| --- |
| - static Allocator m\_Instance; |
| + unsigned long Alloc(MapNode map[], unsigned long size); + unsigned long Free(MapNode map[], unsigned long size, unsigned long addrIdx); + static Allocator& GetInstance(); |

| class BitMapAllocator |
| --- |
| - static BitMapAllocator m\_Instance\_bitmap; |
| + unsigned long Alloc(BitMap &bitmap, unsigned long size); + unsigned long Free(BitMap &bitmap, unsigned long size, unsigned long addrIdx); + int is\_free(BitMap &bitmap, int index); + void set\_bit(BitMap &bitmap, int index, int value); + static BitMapAllocator &GetInstance(); |

23

<!-- Slide number: 24 -->
# 存储空间管理

<MapNode.h>
| struct MapNode |
| --- |
| + unsigned long m\_Size; + unsigned long m\_AddressIdx; |
| class BitMap |
| --- |
| + unsigned long m\_AddressIdx; + int rows; + unsigned long long int map[256]; |
<PageManager.h>
<PageManager.cpp>
| class PageManager |
| --- |
| + MapNode map[PageManager::MEMORY\_MAP\_ARRAY\_SIZE]; - Allocator\* m\_pAllocator; |
| /\* 设置m\_pAllocator \*/ + PageManager(Allocator\* allocator); /\* 初始化分区表map \*/ + int Initialize(); /\* 调用m\_pAllocator->Alloc完成内存分配 \*/ + unsigned long AllocMemory(unsigned long size); /\* 调用m\_pAllocator->Free完成内存回收 \*/ + unsigned long FreeMemory(unsigned long size, unsigned long memoryStartAddress); |
用位示图管理内存

<Allocator.h>
<Allocator.cpp>
| class Allocator |
| --- |
| - static Allocator m\_Instance; |
| + unsigned long Alloc(…); + unsigned long Free(…); + static Allocator& GetInstance(); |
| class BitMapAllocator |
| --- |
| - static BitMapAllocator m\_Instance\_bitmap; |
| + unsigned long Alloc(…); + unsigned long Free(…); + int is\_free(BitMap &bitmap, int index); + void set\_bit(BitMap &bitmap, int index, int value); + static BitMapAllocator &GetInstance(); |
24

<!-- Slide number: 25 -->
# 存储空间管理

<MapNode.h>
| struct MapNode |
| --- |
| + unsigned long m\_Size; + unsigned long m\_AddressIdx; |
| class BitMap |
| --- |
| + unsigned long m\_AddressIdx; + int rows; + unsigned long long int map[256]; |
<PageManager.h>
<PageManager.cpp>
| class PageManager |
| --- |
| + MapNode map[PageManager::MEMORY\_MAP\_ARRAY\_SIZE]; - BitMap Allocator\* m\_pAllocator; + BitMap bitmap; - BitMap Allocator\* bm\_pAllocator; |
| /\* 设置m\_pAllocator \*/ + PageManager(Allocator\* allocator); /\* 设置bm\_pAllocator \*/ + PageManager(BitMapAllocator \*allocator); /\* 初始化位示图bitmap \*/ + int Initialize(); /\* 调用m\_pAllocator->Alloc完成内存分配 \*/ + unsigned long AllocMemory(…); /\* 调用m\_pAllocator->Free完成内存回收 \*/ + unsigned long FreeMemory(…); |
用位示图管理内存

<Allocator.h>
需要添加关于位示图的数据成员

<Allocator.cpp>
| class Allocator |
| --- |
| - static Allocator m\_Instance; |
| + unsigned long Alloc(…); + unsigned long Free(…); + static Allocator& GetInstance(); |
添加一个使用位示图的构造函数

| class BitMapAllocator |
| --- |
| - static BitMapAllocator m\_Instance\_bitmap; |
| + unsigned long Alloc(…); + unsigned long Free(…); + int is\_free(BitMap &bitmap, int index); + void set\_bit(BitMap &bitmap, int index, int value); + static BitMapAllocator &GetInstance(); |
接口不变，所有实现需修改为针对位示图的实现
25

<!-- Slide number: 26 -->
# 存储空间管理
0

2M
页表区
4M
用户区
<PageManager.h>
| class KernelPageManager : public PageManager |
| --- |
|  |
| + KernelPageManager(Allocator\* allocator); /\* 初始化MapNode map[0]为内核物理页区起始地址、大小 \*/ + int Initialize(); |
<PageManager.cpp>
| class PageManager |
| --- |
| + MapNode map[PageManager::MEMORY\_MAP\_ARRAY\_SIZE]; - BitMap Allocator\* m\_pAllocator; + BitMap bitmap; - BitMap Allocator\* bm\_pAllocator; |
| /\* 设置m\_pAllocator \*/ + PageManager(Allocator\* allocator); /\* 设置bm\_pAllocator \*/ + PageManager(BitMapAllocator \*allocator); /\* 初始化位示图bitmap \*/ + int Initialize(); /\* 调用m\_pAllocator->Alloc完成内存分配 \*/ + unsigned long AllocMemory(…); /\* 调用m\_pAllocator->Free完成内存回收 \*/ + unsigned long FreeMemory(…); |

用位示图管理内存
负责管理页表区，其map初始化为：
map[0]. m_AddressIdx = 2M+16K，即：从204号页框开始。 map[0]. m_Size = 2M-16K，即：剩余的页表区。

| class UserPageManager : public PageManager |
| --- |
|  |
| + UserPageManager(Allocator\* allocator); /\* 初始化MapNode map[0]为内核物理页区起始地址、大小 \*/ + int Initialize(); |
用户区，其map初始化为：
map[0]. m_AddressIdx = 4M，大小至整个物理内存。
26

<!-- Slide number: 27 -->
# 存储空间管理
0

2M
页表区
4M
用户区
<PageManager.h>
| class KernelPageManager : public PageManager |
| --- |
|  |
| + KernelPageManager(Allocator\* allocator); + KernelPageManager(BitMapAllocator \*allocator); /\* 初始化MapNode map[0]为内核物理页区起始地址、大小 \*/ + int Initialize(); |
<PageManager.cpp>
| class PageManager |
| --- |
| + MapNode map[PageManager::MEMORY\_MAP\_ARRAY\_SIZE]; - BitMap Allocator\* m\_pAllocator; + BitMap bitmap; - BitMap Allocator\* bm\_pAllocator; |
| /\* 设置m\_pAllocator \*/ + PageManager(Allocator\* allocator); /\* 设置bm\_pAllocator \*/ + PageManager(BitMapAllocator \*allocator); /\* 初始化位示图bitmap \*/ + int Initialize(); /\* 调用m\_pAllocator->Alloc完成内存分配 \*/ + unsigned long AllocMemory(…); /\* 调用m\_pAllocator->Free完成内存回收 \*/ + unsigned long FreeMemory(…); |

添加构造函数，修改初始化操作
用位示图管理内存
负责管理页表区，其bitmap初始化为：
map[0]. m_AddressIdx = 2M+16K，即：从204号页框开始。 map[0]. m_Size = 2M-16K，即：剩余的页表区。

| class UserPageManager : public PageManager |
| --- |
|  |
| + UserPageManager(Allocator\* allocator); + UserPageManager(BitMapAllocator \*allocator); /\* 初始化MapNode map[0]为内核物理页区起始地址、大小 \*/ + int Initialize(); |

添加构造函数，修改初始化操作
用户区，其bitmap初始化为：
map[0]. m_AddressIdx = 4M，大小至整个物理内存。
27

<!-- Slide number: 28 -->
# 需要完成的设计内容
离散化存储
28
