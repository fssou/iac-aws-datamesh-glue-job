package in.francl.data.datamesh.glue

import com.amazonaws.services.glue.{DynamicFrame, GlueContext, MappingSpec}
import com.amazonaws.services.glue.util.Job
import com.amazonaws.services.glue.GlueContext
import com.amazonaws.services.glue.errors.CallSite
import com.amazonaws.services.glue.util.GlueArgParser
import com.amazonaws.services.glue.util.Job
import com.amazonaws.services.glue.util.JsonOptions
import com.amazonaws.services.gluedatabrew.model.CsvOptions
import org.apache.spark.SparkContext
import org.apache.spark.sql.SaveMode
import org.apache.spark.sql.functions._
import org.apache.spark.sql.types.{DateType, LongType, Metadata, StringType, StructField, StructType}

import scala.collection.JavaConverters._

object GlueApp {

    def main(sysArgs: Array[String]): Unit = {
        val spark: SparkContext = new SparkContext()
        val glueContext: GlueContext = new GlueContext(spark)
        val args = GlueArgParser.getResolvedOptions(
            sysArgs,
            Seq(
                "JOB_NAME",
                "SOURCE_PATH",
                "TARGET_PATH"
            ).toArray
        )
        val job = Job.init(args("JOB_NAME"), glueContext, args.asJava)

        val sourcePath: String = args("SOURCE_PATH")
        val targetPath: String = args("TARGET_PATH")

        val schema = StructType(
            Array(
                StructField("PEOPLE_POSITIVE_CASES_COUNT",      LongType,   nullable = true),
                StructField("COUNTY_NAME",                      StringType, nullable = true),
                StructField("PROVINCE_STATE_NAME",              StringType, nullable = true),
                StructField("REPORT_DATE",                      DateType,   nullable = true),
                StructField("CONTINENT_NAME",                   StringType, nullable = true),
                StructField("DATA_SOURCE_NAME",                 StringType, nullable = true),
                StructField("PEOPLE_DEATH_NEW_COUNT",           LongType,   nullable = true),
                StructField("COUNTY_FIPS_NUMBER",               LongType,   nullable = true),
                StructField("COUNTRY_ALPHA_3_CODE",             StringType, nullable = true),
                StructField("COUNTRY_SHORT_NAME",               StringType, nullable = true),
                StructField("COUNTRY_ALPHA_2_CODE",             StringType, nullable = true),
                StructField("PEOPLE_POSITIVE_NEW_CASES_COUNT",  LongType,   nullable = true),
                StructField("PEOPLE_DEATH_COUNT",               LongType,   nullable = true),
            )
        )

        val dataFrame = glueContext.read
            .option("header", "true")
            .schema(schema)
            .csv(sourcePath)

        val columnsLowerCase = dataFrame.columns.map(_.toLowerCase)

        val dataFrameCoalesce = dataFrame
            .select(columnsLowerCase.map(col): _*)
            .withColumn("part_report_date", col("report_date"))
            .withColumn("part_country_alpha_2_code", col("country_alpha_2_code"))
            .withColumn("part_continent_name", col("continent_name"))

        dataFrameCoalesce
            .repartition(1)
            .write
            .mode(SaveMode.Overwrite)
            .partitionBy(
                "part_report_date",
                "part_country_alpha_2_code",
                "part_continent_name",
            )
            .parquet(targetPath)

        job.commit()
    }

}
