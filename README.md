# Summary
## Older Versions of Spark

* Compatibility: Livy is compatible with older versions of Scala and Spark.
* Scala Version: The packaged version of Livy works only with Scala 2.11.
* Provided Jars: Comes with pre-packaged jars for Scala 2.11.

## Newer Versions of Spark

* Support: Newer versions of Spark are untested and unsupported by the regular Livy downloads.
* Build Issues: Compiling Livy for newer versions of Spark often fails in its current state.
* Workarounds:
    * You can compile Livy for later versions of Spark and skip tests
    * The python/setup.py script is broken in the official repository but is fixed in my fork.
