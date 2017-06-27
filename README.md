# MKCoreData

# CoreData

## 引言

前面介绍过SQLite3的基本使用，抛开性能效率因素，SQL查询语句能给人一种自然易懂的亲切感，coreData初用着估计会有些绕的感觉，但一样，熟能生巧。作为iOS开发者，熟练使用coreData，重要性是不言而喻的，毕竟这是Apple提供和推荐的。对项目来说，无论是选用FMDB还是CoreData，都只是作为工具去实现数据持久化存储，但对于开发者来说，能不能快速在二者之间进行切换，显得尤为重要（懂得）！

距离上次使用coreData做数据持久化，还是一年前，有个电商类APP，需要本地记录用户的搜索偏好，然后将数据发送服务器保存，经过分析处理，用作给客户端推送相关产品的依据（成熟的电商类APP基本都有这个功能）。

是啊，一年前还是做电商类APP，如今是走在游戏加班的道路上。得空，再把coreData的基本用法，以及涉及的多线程问题，在这里整理下。

## 拓展

 * 1、NSManagedObjectContext 数据上下文，负责数据的实际操作，如：插入数据、查询数据、删除数据、更新数据。
 
 * 2、NSPersistentStoreCoordinator 持久化存储助理。设置数据存储的名字、位置、存储方式和存储时机。
 * 3、NSManagedObjectModel数据模型。数据库所有表格和数据模型，包含各个实体定义信息，添加实体属性，建立属性之间的联系。可通过试图编辑器和代码进行编辑。
 * 4、NSManagedObject 被管理的数据。数据库中的表格记录。
 * 5、NSEntityDescription 实体结构。相当于表格结构。
 * 6、NSFetchRequest 数据请求。相当于查询语句。
 * 7、.xcdatamodeld 里面是.xcdatamodel文件，用数据模型编辑器编辑，编译后为.momd或者.mom文件。 

![](https://github.com/maojingios/MKCoreData/blob/master/picture0.png)

## 正文

#### 1、基本用法。这里介绍基本增、删、查、改的用法。详见工程BasicUse单利类。

	#import <Foundation/Foundation.h>
	#import <CoreData/CoreData.h>
	#import "Person+CoreDataClass.h"
	
	@interface BasicUse : NSObject
	
	@property (nonatomic, readwrite, strong)NSManagedObjectContext * context;
	
	+(__kindof BasicUse *)manager;
	
	/*
	 准备
	 */
	-(void)prepare;
	
	/*
	 插入数据
	 */
	-(void)insert;
	
	/*
	 查询
	 */
	-(void)query;
	
	/*
	 删除
	 */
	-(void)mkDelete;
	
	/*
	 修改
	 */
	-(void)update;
	
	@end

#### 2、调用

    [[BasicUse manager] prepare];
    [[BasicUse manager] insert]; //增
    [[BasicUse manager] query]; //查
    [[BasicUse manager] mkDelete];//删
    [[BasicUse manager] update];//改



#### 3、关于coreData工程配置注意（xcode 8.3 OC）：

* 语言选择。如图A标注，在language栏根据需要进行切换。 

![](https://github.com/maojingios/MKCoreData/blob/master/picture1.png)

* NSManagedObject SubClass 创建如下图1、2、3标注。

![](https://github.com/maojingios/MKCoreData/blob/master/picture2.png)

* 关于如下图报错，请将图B标注Minimum设置为低版本、或者再将Codegen设置为Manual/None,最后编译。  

![](https://github.com/maojingios/MKCoreData/blob/master/picture3.png)

![](https://github.com/maojingios/MKCoreData/blob/master/picture4.png)

#### 4、线程。coreData是线程不安全的，在大量操作数据时，为了保证UI不被卡住，多线程使用是必不可少的。
 
 * coredata与多线程交互的时候，每个线程都须拥有一个manager context对象，以下为两种方式：
 1、每一个线程使用私有的manager context，共享一个 persistent store coordinator；2、每个线程使用私有的manager context和私有的persistent store coordinator
这里推荐使用第一钟方式，第二种方式的会消耗我们更多的内存。CoreData里面还带有一个通知NSManagedObjectContextDidSaveNotification，主要监听NSManagedObjectContext的数据是否改变，并合并数据改变到相应context通常主线程context使用NSMainQueueConcurrencyType,其他线程childContext使用NSPrivateQueueConcurrencyType. child和parent的特点是要用Block进行操作,performBlock,或者performBlockAndWait，保证线程安全。这两个函数的区别是performBlock不会阻塞运行的线程，相当于异步操作，performBlockAndWait会阻塞运行线程，相当于同步操作。 


* 使用三层 NSManagedObjectContext 嵌套的方式。
NSManagedObjectContext是可以基于其他的 NSManagedObjectContext的，通过 setParentContext 方法，可以设置另外一个 NSManagedObjectContext 为自己的父级，这个时候子级可以访问父级下所有的对象，而且子级 NSManagedObjectContext 的内容变化后，如果执行save方法，会自动的 merge 到父级 NSManagedObjectContext 中，也就是子级save后，变动会同步到父级 NSManagedObjectContext。当然这个时候父级也必须再save一次，如果父级没有父级了，那么就会直接向NSPersistentStoreCoordinator中写入，如果有就会接着向再上一层的父级冒泡……
那么这里如同参考的文章一样，通过三个级别的 NSManagedObjectContext， 一个负责在background更新NSPersistentStoreCoordinator。一个用在主线程，主要执行插入，修改和删除操作，一些小的查询也可以在这里同步执行，如果有大的查询，就起一个新的 NSPrivateQueueConcurrencyType 类型的 NSManagedObjectContext，然后放在后台去执行查询，查询完成后将结果返回主线程。
 
 
 
## 总结

coreData使用起来还是非常OC的，但要注意，设置value和key时不能出错。最后还是老生常谈的话题，到底FMDB和coreData，那个好？其实开篇就有回答这个问题--（对项目来说，无论是选用FMDB还是CoreData，都只是作为工具去实现数据持久化存储...），现在硬件运算力越来越强，大多数情况下，二者性能上优劣，体现在UI层面上来，让人是觉察不了的。

最后还是那句话：无论是选用FMDB还是CoreData，都只是作为工具去实现数据持久化存储，但对于开发者来说，能不能快速在二者之间进行切换，显得尤为重要（懂得）！
   
