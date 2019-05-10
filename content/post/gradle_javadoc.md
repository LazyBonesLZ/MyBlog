---
title: "Android Studio: compileDebugJavaWithJavac issue"
date: 2019-05-10T15:03:34+08:00
draft: fasle
categories: [Android]
tags: [compileDebugJavaWithJavac,编译错误]
---

Android Studio编译，运行遇到  `Execution failed for task ':customviews:compileDebugJavaWithJavac'`, 一大堆的错误log，却找不到问题所在，无从下手。<!--more-->

``` shell 
Caused by: org.gradle.api.tasks.TaskExecutionException: Execution failed for task ':customviews:compileDebugJavaWithJavac'.
	at org.gradle.api.internal.tasks.execution.ExecuteActionsTaskExecuter.execute(ExecuteActionsTaskExecuter.java:95)
	at org.gradle.api.internal.tasks.execution.ResolveTaskOutputCachingStateExecuter.execute(ResolveTaskOutputCachingStateExecuter.java:91)
	at org.gradle.api.internal.tasks.execution.ValidatingTaskExecuter.execute(ValidatingTaskExecuter.java:57)
	at org.gradle.api.internal.tasks.execution.SkipEmptySourceFilesTaskExecuter.execute(SkipEmptySourceFilesTaskExecuter.java:119)
	at org.gradle.api.internal.tasks.execution.ResolvePreviousStateExecuter.execute(ResolvePreviousStateExecuter.java:43)
	at org.gradle.api.internal.tasks.execution.CleanupStaleOutputsExecuter.execute(CleanupStaleOutputsExecuter.java:93)
	at org.gradle.api.internal.tasks.execution.FinalizePropertiesTaskExecuter.execute(FinalizePropertiesTaskExecuter.java:45)
	at org.gradle.api.internal.tasks.execution.ResolveTaskArtifactStateTaskExecuter.execute(ResolveTaskArtifactStateTaskExecuter.java:94)
	at org.gradle.api.internal.tasks.execution.SkipTaskWithNoActionsExecuter.execute(SkipTaskWithNoActionsExecuter.java:56)
	at org.gradle.api.internal.tasks.execution.SkipOnlyIfTaskExecuter.execute(SkipOnlyIfTaskExecuter.java:55)
	at org.gradle.api.internal.tasks.execution.CatchExceptionTaskExecuter.execute(CatchExceptionTaskExecuter.java:36)
	at org.gradle.api.internal.tasks.execution.EventFiringTaskExecuter$1.executeTask(EventFiringTaskExecuter.java:67)
	at org.gradle.api.internal.tasks.execution.EventFiringTaskExecuter$1.call(EventFiringTaskExecuter.java:52)
	at org.gradle.api.internal.tasks.execution.EventFiringTaskExecuter$1.call(EventFiringTaskExecuter.java:49)
	at org.gradle.internal.operations.DefaultBuildOperationExecutor$CallableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:315)
	at org.gradle.internal.operations.DefaultBuildOperationExecutor$CallableBuildOperationWorker.execute(DefaultBuildOperationExecutor.java:305)
	at org.gradle.internal.operations.DefaultBuildOperationExecutor.execute(DefaultBuildOperationExecutor.java:175)
	at org.gradle.internal.operations.DefaultBuildOperationExecutor.call(DefaultBuildOperationExecutor.java:101)
	at org.gradle.internal.operations.DelegatingBuildOperationExecutor.call(DelegatingBuildOperationExecutor.java:36)
	at org.gradle.api.internal.tasks.execution.EventFiringTaskExecuter.execute(EventFiringTaskExecuter.java:49)
	at org.gradle.execution.plan.LocalTaskNodeExecutor.execute(LocalTaskNodeExecutor.java:43)
	at org.gradle.execution.taskgraph.DefaultTaskExecutionGraph$InvokeNodeExecutorsAction.execute(DefaultTaskExecutionGraph.java:355)
	at org.gradle.execution.taskgraph.DefaultTaskExecutionGraph$InvokeNodeExecutorsAction.execute(DefaultTaskExecutionGraph.java:343)
	at org.gradle.execution.taskgraph.DefaultTaskExecutionGraph$BuildOperationAwareExecutionAction.execute(DefaultTaskExecutionGraph.java:336)
	at org.gradle.execution.taskgraph.DefaultTaskExecutionGraph$BuildOperationAwareExecutionAction.execute(DefaultTaskExecutionGraph.java:322)
	at org.gradle.execution.plan.DefaultPlanExecutor$ExecutorWorker$1.execute(DefaultPlanExecutor.java:134)
	at org.gradle.execution.plan.DefaultPlanExecutor$ExecutorWorker$1.execute(DefaultPlanExecutor.java:129)
	at org.gradle.execution.plan.DefaultPlanExecutor$ExecutorWorker.execute(DefaultPlanExecutor.java:202)
	at org.gradle.execution.plan.DefaultPlanExecutor$ExecutorWorker.executeNextNode(DefaultPlanExecutor.java:193)
	at org.gradle.execution.plan.DefaultPlanExecutor$ExecutorWorker.run(DefaultPlanExecutor.java:129)
	... 6 more

```

可以在 `Terminal`执行 

```
./gradlew compileDebugJavaWithJavac
```
很快就能从执行结果中找到问题所在：

``` shell 
$ ./gradlew compileDebugJavaWithJavac

> Task :customviews:compileDebugJavaWithJavac FAILED
/Users/WorkInfos/999-TJL/99-Demo/03/LazySDK/customviews/src/main/java/com/lazy/customviews/bookflipview/baselib/FoldBackVertexProgram.java:61: 错误: 程序包R不存在
                   R.raw.fold_back_vertex_shader,
                    ^
/Users/WorkInfos/999-TJL/99-Demo/03/LazySDK/customviews/src/main/java/com/lazy/customviews/bookflipview/baselib/FoldBackVertexProgram.java:62: 错误: 程序包R不存在
                   R.raw.fold_back_fragment_shader);
                    ^
2 个错误

FAILURE: Build failed with an exception.

* What went wrong:
Execution failed for task ':customviews:compileDebugJavaWithJavac'.
```

扩展一下，是不是执行gradle task出现的编译错误，都可以用这种方式来定位问题呢？
有机会遇到了再验证一下。

