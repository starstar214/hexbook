:currency_exchange: **Elasticsearch-高扩展的分布式全文搜索引擎**



---

#### 1.Elasticsearch 概述

在信息社会，数据可以被划分为 3 大类：

1. 结构化数据：结构化的数据是可以使用关系型数据库表示和存储的数据，表现为二维形式的数据，也就是传统 DBMS 数据库存储的信息。

2. 半结构化数据：半结构化数据是结构化数据的一种形式，它包含相关标记，用来分隔语义元素以及对记录和字段进行分层，因此它也被称为自描述的结构。常见的半结构数据有 XML 和 JSON 等。

3. 非结构化数据：非结构化数据的数据结构不规则或不完整，也没有预定义数据模型，常见的如各种文本、图片、视频/音频等。

传统的 DBMS 数据库对于非结构化数据的存储和查询的能力非常有限，而 Elasticsearch 的出现解决了这一问题，它适用于包括文本、数字、地理空间、结构化和非结构化数据等在内的所有类型的数据，并对它们进行搜索和分析。



Lucene 与 Elasticsearch、Solr：

Lucene 是 Apache 软件基金会 Jakarta 项目组的一个子项目，提供了一个简单却强大的应用程式接口，能够做全文索引和搜寻。但 Lucene 只是一个提供全文搜索功能类库的核心工具包，而真正使用它还需要一个完善的服务框架搭建起来进行应用。
目前市面上流行的搜索引擎软件，主流的就两款：Elasticsearch 和 Solr，这两款都是基于 Lucene 搭建的，可以独立部署启动的搜索引擎服务软件。



Elasticsearch 和 Solr 对比：

1. 相对于 Solr 来说，Elasticsearch 更加轻量级且易于安装。

   例如：安装 Solr 时还需要安装 Zookeeper 进行分布式管理，而 Elasticsearch 自身带有分布式协调管理功能。

2. Solr 支持更多格式的数据，如 JSON、XML、CSV，而 Elasticsearch 仅支持 JSON 类型的数据。

3. Solr 的查询性能更好但索引更新速度不如 Elasticsearch（所以 Elasticsearch 对实时搜索功能支持更好）。

4. Elasticsearch 相比于 Solr 而言暴露了更多的监控和指标，更好地帮助我们处理分析查询。

5. Elasticsearch 的可伸缩性和分布式环境的支持更加的优于 Solr。

> :eagle: 所以，Solr 更加适合于传统的搜索引擎（如：电子图书馆，离线搜索应用等），而 Elasticsearch 更加适合于分布式的实时搜索的应用（如：FaceBook，微博）。



---

#### 2.Elasticsearch 安装

Elasticsearch 官网：https://www.elastic.co/cn/elasticsearch/



在安装 Elasticsearch 之前，需要先安装 java 环境。

~~~shell
[root@localhost ~]# dnf install java-1.8.0-openjdk-devel.x86_64
~~~

在官网上提供了使用 dnf 命令在线安装 Elasticsearch 的方法：

1. 在 `/etc/yum.repos.d/` 路径下新建 `elasticsearch.repo` 文件，文件内容如下：

   ~~~properties
   [elasticsearch]
   name=Elasticsearch repository for 7.x packages
   baseurl=https://artifacts.elastic.co/packages/7.x/yum
   gpgcheck=1
   gpgkey=https://artifacts.elastic.co/GPG-KEY-elasticsearch
   enabled=0
   autorefresh=1
   type=rpm-md
   ~~~

   这一步及手动的添加了 Elasticsearch 的 yum 源。

2. 使用 dnf 命令进行安装：

   ~~~shell
   [root@localhost ~]# dnf install --enablerepo=elasticsearch elasticsearch
   ~~~

   使用 `systemctl start elasticsearch.service` 即可启动 Elasticsearch 服务。



在启动 Elasticsearch 后，Elasticsearch 将会暴露 9200 端口为浏览器的 RESTful 接口访问端口。

使用 curl 命令即可与 Elasticsearch 进行通信：

~~~shell
[root@localhost elasticsearch]# curl -XGET localhost:9200
{
  "name" : "localhost.localdomain",
  "cluster_name" : "elasticsearch",
  "cluster_uuid" : "trH5F2nvQa2uXy9QjIF7TQ",
  "version" : {
    "number" : "7.14.0",
    "build_flavor" : "default",
    "build_type" : "rpm",
    "build_hash" : "dd5a0a2acaa2045ff9624f3729fc8a6f40835aa1",
    "build_date" : "2021-07-29T20:49:32.864135063Z",
    "build_snapshot" : false,
    "lucene_version" : "8.9.0",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
~~~

配置 Elasticsearch 的远程访问，配置文件地址：`/etc/elasticsearch/elasticsearch.yml`

修改内容：

~~~yml
node.name: node-1 # 当前节点名称
network.host: 0.0.0.0  # 允许任何 IP 地址进行访问
cluster.initial_master_nodes: ["node-1"]  # Elasticsearch 默认节点名
~~~

开启虚拟机 9200、9300 端口的防火墙对应端口，然后就可以从其他 IP 地址对 Elasticsearch 进行访问。



---

#### 3.Elasticsearch 索引

Elasticsearch 的数据格式：

1. 索引（Index）：类比于 MySQL 中的数据库对象。
2. 类型（Type）：类比于 MySQL 中的表，在 7.x 中此类型已被删除。
3. 文档（Documents）：类比于 MySQL 中的行数据，也就是一条数据记录。
4. 字段（Field）：类比于 MySQL 中的列。



Elasticsearch 索引操作：

1. 创建索引 Index（类似于创建 MySQL 数据库）

   向 Elasticsearch 发送 PUT 请求：http://192.168.253.132:9200/shopping，得到响应：

   ~~~json
   {
       "acknowledged": true,
       "shards_acknowledged": true,
       "index": "shopping"
   }
   ~~~

2. 获取索引信息：将请求改为 GET 发送即可。

3. 获取 Elasticsearch 中所有 Index 信息：http://192.168.253.132:9200/_cat/indices?v=true（GET）

   ~~~shell
   health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
   green  open   .geoip_databases KFILY5sQS3Sc1LXzjDLbVw   1   0         41           37     40.1mb         40.1mb
   yellow open   shopping         4Fi0ScYKSHetH7HcNbIgtQ   1   1          0            0       208b           208b
   ~~~

   不加参数 v=true 时，只展示简略信息。信息中各个参数含义：

   | 参数名         | 含义                                                         |
   | -------------- | ------------------------------------------------------------ |
   | health         | 当前服务器健康状态：green（集群完整）、yellow（单点正常，集群不完整）、red（单点不正常） |
   | status         | 索引打开、关闭状态                                           |
   | index          | 索引名                                                       |
   | uuid           | 索引编号 uuid                                                |
   | pri            | 主分片数量                                                   |
   | rep            | 副本数量                                                     |
   | docs.count     | 可用文档数量                                                 |
   | docs.deleted   | 文档删除个数（逻辑删除）                                     |
   | store.size     | 主分片和副分片整体占用空间大小                               |
   | pri.store.size | 主分片占用空间大小                                           |

4. 删除索引：将请求改为 DELETE 发送即可。



---

#### 4.Elasticsearch 文档

Elasticsearch 中常用的 HTTP 方法：

| HTTP 方法 | 描述                                                         |
| --------- | ------------------------------------------------------------ |
| GET       | 请求指定的资源信息，返回实体主体                             |
| POST      | 向指定资源提交数据处理请求（POST 请求可能会导致新的资源的建立或已有资源的修改） |
| PUT       | 从客户端向服务器传送取代指定资源的信息（全量修改）           |
| DELETE    | 请求服务器删除指定的资源                                     |

> :basketball_man: 幂等性：就是用户对于同一操作发起的一次请求或者多次请求的结果是一致的，不会因为多次点击而产生了副作用。
>
> 在 Elasticsearch 中，除 POST 请求之外其他请求都要求是幂等性的。



添加数据：

1. 不指定 ID 添加数据：向 Elasticsearch 发送 POST 请求，请求路径为

   ~~~http
   http://192.168.253.132:9200/xxx/_doc
   ~~~

   其中 xxx 为索引名，需要添加的文档数据放在 Request Body 中进行发送（发送的数据应该为 JSON 数据），返回的数据为：

   ~~~json
   {
       "_index": "shopping",
       "_type": "_doc",
       "_id": "5uWVK3sBFN0MjPUocWeh",
       "_version": 1,
       "result": "created",
       "_shards": {
           "total": 2,
           "successful": 1,
           "failed": 0
       },
       "_seq_no": 0,
       "_primary_term": 1
   }
   ~~~

   由于没有手动指定唯一标识，Elasticsearch 将自动生成 _id。

2. 指定 ID 添加数据：向 Elasticsearch 发送 POST/PUT 请求，请求路径为

   ~~~http
   http://192.168.253.132:9200/xxx/_doc/1
   ~~~

   由于在手动添加了 ID 后，无论发送了多少次请求，产生的结果都是一样的，满足了请求的幂等性，所以该请求也可以使用 PUT 请求进行发送。

   > :chart_with_downwards_trend: 指定 ID 发送请求时，如果存在该 ID 的数据，就是在原基础上进行更新（会更改 version 值）

   指定 id 进行文档添加/更新的 url 也可以是：

   ~~~http
   http://192.168.253.132:9200/shopping/_create/2
   ~~~

   注意：使用 `_create` 添加/更新文档时必须指定 ID。



修改文档数据：

1. 全量修改：即 POST/PUT 请求`http://192.168.253.132:9200/xxx/_doc/1`（不存在数据时创建，存在数据时全量更新）

2. 部分修改：POST 请求`http://192.168.253.132:9200/xxx/_update/1`，发送的 Request Body 如下

   ~~~json
   {
       "doc": {
           "price": 3333
       }
   }
   ~~~

   即值进行 price 的修改。



删除文档数据：DELEE 请求`http://192.168.253.132:9200/xxx/_doc/1`



查询文档数据：

1. 按照 ID 查找文档数据：

   ~~~http
   http://192.168.253.132:9200/shopping/_doc/1
   ~~~

2. 查找索引下的所有文档数据：

   ~~~http
   http://192.168.253.132:9200/shopping/_search
   ~~~

条件查询：

1. 按照指定条件进行查询：

   ~~~http
   http://192.168.253.132:9200/shopping/_search?q=price:3999
   ~~~

   或者将查询条件放入 Body 中：`http://192.168.253.132:9200/shopping/_search`，请求体为

   ~~~json
   {
       "query": {
           "match": {
               "price": 3333
           }
       }
   }
   ~~~

2. 分页查询：`http://192.168.253.132:9200/shopping/_search`，请求体为

   ~~~json
   {
       "query": {
           "match_all": {}
       },
       "from": 0,
       "size": 2
   }
   ~~~

3. 查询时指定显示的字段：

   ~~~json
   {
       "query": {
           "match_all": {}
       },
       "_source": ["price","title"]
   }
   ~~~

   也可以使用排除和包含的方式进行指定：

   ~~~json
   {
       "query": {
           "match_all": {}
       },
       "_source": {
           "include": [
               "images"
           ],
           "exclude": [
               "price"
           ]
       }
   }
   ~~~

4. 按照字段进行排序：

   ~~~json
   {
       "query": {
           "match_all": {}
       },
       "sort": {
           "price": {
               "order": "asc"
           }
       }
   }
   ~~~

5. 多条件查询：

   ~~~json
   {
       "query": {
           "bool": {
               "must": [
                   {
                       "match": {
                           "category": "小米"
                       }
                   },
                   {
                       "match": {
                           "title": "小米手机"
                       }
                   }
               ],
               "filter": {
                   "range": {
                       "price": {
                           "gt": 2999,
                           "lte": 3999
                       }
                   }
               }
           }
       }
   }
   ~~~

   - must 指全部满足（多个条件同时成立），如果需要或的逻辑则使用 should。
   - gt 为大于，lt 为小于，gte 为大于等于，lte 为小于等于。

6. 全文检索，使用 match 进行匹配时默认进行的是模糊分词匹配：

   ~~~json
   {
       "query": {
           "match": {
               "title": "小青"
           }
       }
   }
   ~~~

   输入 "小青"，仍能匹配到 "小米手机"，因为 Elasticsearch 底层采用分词进行模糊匹配，如果需要精确匹配，则使用：

   ~~~json
   {
       "query": {
           "match_phrase": {
               "title": "小青"
           }
       }
   }
   ~~~

7. 对查询结果高亮处理：

   ~~~json
   {
       "query": {
           "match": {
               "title": "小米"
           }
       },
       "highlight": {
           "fields": {
               "title": {}
           }
       }
   }
   ~~~

8. 聚合查询：

   ~~~json
   {
       "aggs": { // 分组查询
           "price_group": { // 组名，随意取
               "terms": {
                   "field": "price"  // 分组字段
               }
           }
       },
       "size": 0  // 不显示原始数据
   }
   ~~~

   平均值查询：

   ~~~json
   {
       "aggs": {
           "price_avg": {
               "avg": {
                   "field": "price"
               }
           }
       },
       "size": 0
   }
   ~~~

   

---

#### 5.Elasticsearch 映射

Elasticsearch 中的映射类似于 MySQL 中的表结构，创建数据库表需要设置字段名称，类型，长度，约束等；索引库也一样，需要知道这个类型下有哪些字段，每个字段有哪些约束信息，这就叫做映射（mapping）。



创建映射：POST 请求`http://192.168.253.132:9200/user/_mapping`

~~~json
{
    "properties": {
        "name": {
            "type": "text", // 文本类型
            "index": true   // 可以被索引
        },
        "gender": {
            "type": "keyword", // 关键字，不能被分词索引
            "index": true
        },
        "phoneNumber": {
            "type": "text",
            "index": false
        }
    }
}
~~~



> :yum: 映射不会影响向 Index 中添加数据，只会限制数据的查询。



映射的字段说明：

1. type：类型，常见的类型如下

   1. 字符串：text（可分词）、keyword（不可分词）
   2. 数值类型：可以分两类
      1. 基本数据类型：long、integer、short、byte、double、float、half_float
      2. 浮点数的高精度类型：scaled_float
   3. 日期类型：date
   4. 数组类型：array
   5. 对象：object

2. index：是否允许被索引，默认为 true。

3. store：是否将数据进行独立存储，默认为 false。

   > 原始的文本会存储在 \_source 里面，默认情况下其他提取出来的字段都不是独立存储的，是从 \_source 里面提取出来的。
   >
   > 我们也可以独立的存储某个字段，只要设置 "store": true 即可，获取独立存储的字段要比从_source中解析快得多，但是也会占用更多的空间，所以要根据实际业务需求来设置。

4. analyzer：分词器，指定使用的分词器。



---

#### 6.Java 操作 Elasticsearch 

搭建 Maven 项目，引入依赖：

~~~xml
<dependency>
    <groupId>org.elasticsearch</groupId>
    <artifactId>elasticsearch</artifactId>
    <version>7.9.3</version>
</dependency>
<dependency>
    <groupId>org.elasticsearch.client</groupId>
    <artifactId>elasticsearch-rest-high-level-client</artifactId>
    <version>7.9.3</version>
</dependency>
~~~



使用客户端连接 Elasticsearch：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
// 执行操作
client.close();
~~~

创建索引：

~~~java
IndicesClient indicesClient = client.indices();
CreateIndexRequest indexRequest = new CreateIndexRequest("cars");
CreateIndexResponse response = indicesClient.create(indexRequest, RequestOptions.DEFAULT);
System.out.println("响应状态：" + response.isAcknowledged());
~~~

查询索引：

~~~java
IndicesClient indicesClient = client.indices();
GetIndexRequest getIndexRequest = new GetIndexRequest("cars");
GetIndexResponse getIndexResponse = indicesClient.get(getIndexRequest, RequestOptions.DEFAULT);
System.out.println(getIndexResponse.getAliases());
System.out.println(getIndexResponse.getMappings());
System.out.println(getIndexResponse.getSettings());
~~~

删除索引（DeleteIndexRequest）的操作同理。



创建文档数据：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
IndexRequest indexRequest = new IndexRequest("cars").id("0001");
Car car = new Car().setTitle("全新梅赛德斯-迈巴赫S级轿车").setBrand("梅赛德斯奔驰").setOrigin("德国").setPrice(BigDecimal.valueOf(420000.0));
String jsonStr = JSONUtil.toJsonStr(car);
indexRequest.source(jsonStr, XContentType.JSON);
IndexResponse response = client.index(indexRequest, RequestOptions.DEFAULT);
System.out.println("执行结果：" + response.getResult());
client.close();
~~~

更新文档数据：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
UpdateRequest updateRequest = new UpdateRequest("cars", "0001");
updateRequest.doc(XContentType.JSON, "price", BigDecimal.valueOf(430000.5));
UpdateResponse response = client.update(updateRequest, RequestOptions.DEFAULT);
System.out.println(response.getResult());
client.close();
~~~

按照 ID 查询（GetRequest）与按照 ID 删除（DeleteRequest）操作同理。



批量插入数据：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
BulkRequest request = new BulkRequest();
Car car1 = new Car().setTitle("创新纯电动BMW iX3").setBrand("宝马").setOrigin("德国").setPrice(BigDecimal.valueOf(399900.0));
Car car2 = new Car().setTitle("AVENTADOR SVJ").setBrand("兰博基尼").setOrigin("意大利").setPrice(BigDecimal.valueOf(1200000.0));
request.add(new IndexRequest("cars").id("0002").source(JSONUtil.toJsonStr(car1), XContentType.JSON));
request.add(new IndexRequest("cars").id("0003").source(JSONUtil.toJsonStr(car2), XContentType.JSON));
BulkResponse response = client.bulk(request, RequestOptions.DEFAULT);
System.out.println(response.getTook());
client.close();
~~~

同理，批量删除时也使用 BulkRequest，在 request 中加入多个 DeleteRequest 进行删除。



---

#### 7.Elasticsearch 查询

全量查询：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
SearchRequest searchRequest = new SearchRequest("cars");
searchRequest.source(new SearchSourceBuilder().query(QueryBuilders.matchAllQuery()));
SearchResponse search = client.search(searchRequest, RequestOptions.DEFAULT);
SearchHits hits = search.getHits();
for (SearchHit hit : hits) {
    System.out.println(hit.getSourceAsString());
}
client.close();
~~~



条件查询：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
SearchRequest searchRequest = new SearchRequest("cars");
searchRequest.source(new SearchSourceBuilder().query(QueryBuilders.termQuery("origin.keyword", "德国")));
SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);
// ...
client.close();
~~~

> :bust_in_silhouette: 因为 Elastic 分词器会将字段值进行分词，输入全量字段进行匹配时找不到对应的分词，所以 termQuery 的写法是：
>
> 使用`QueryBuilders.termQuery("origin.keyword", "德国")`进行精确匹配或使用`QueryBuilders.termQuery("origin", "德")`进行模糊搜索.



分页查询、排序、过滤字段：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
SearchRequest searchRequest = new SearchRequest("cars");
SearchSourceBuilder builder = new SearchSourceBuilder().query(QueryBuilders.matchAllQuery());
// 分页参数
builder.from(0);
builder.size(3);
// 排序查询
builder.sort("price", SortOrder.DESC);
// 过滤字段 include title，exclude brand
builder.fetchSource(new String[]{"title"}, new String[]{"brand"});
searchRequest.source(builder);
SearchResponse response = client.search(searchRequest, RequestOptions.DEFAULT);
// ...
client.close();
~~~

组合条件查询、模糊查询、高亮查询：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
BoolQueryBuilder boolQueryBuilder = QueryBuilders.boolQuery();
boolQueryBuilder.must(QueryBuilders.matchQuery("origin.keyword", "德国"));
// 模糊查询，Fuzziness.TWO 指匹配与关键字两个字符查以内的目标
boolQueryBuilder.must(QueryBuilders.fuzzyQuery("title.keyword", "奥迪A").fuzziness(Fuzziness.TWO));
// 范围匹配
boolQueryBuilder.must(QueryBuilders.rangeQuery("price").from(BigDecimal.valueOf(300000.0)).to(BigDecimal.valueOf(1000000.0)));
searchSourceBuilder.query(boolQueryBuilder);
// 高亮查询
HighlightBuilder highlighter = new HighlightBuilder();
highlighter.preTags("<front color='red'>");
highlighter.postTags("</front>");
highlighter.field("origin.keyword");
searchSourceBuilder.highlighter(highlighter);
SearchRequest request = new SearchRequest("cars");
request.source(searchSourceBuilder);
SearchResponse response = client.search(request, RequestOptions.DEFAULT);
SearchHits hits = response.getHits();
for (SearchHit hit : hits) {
    System.out.println(hit.getHighlightFields());
    System.out.println(hit.getSourceAsString());
}
client.close();
~~~



聚合查询：Elasticsearch 中聚合分为了 3 种

1. 桶聚合：将文档按照特定条件的进行分组聚合。
2. 指标聚合：对分组内的文档进行统计计算，如总和、平均值等。
3. 管道聚合：对其他聚合产生的输出进行进一步的处理

最大值查询：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
AggregationBuilder aggregationBuilder = AggregationBuilders.max("maxPrice").field("price");
searchSourceBuilder.aggregation(aggregationBuilder);
SearchRequest request = new SearchRequest("cars");
request.source(searchSourceBuilder);
SearchResponse response = client.search(request, RequestOptions.DEFAULT);
System.out.println("最大值：" + ((ParsedMax) response.getAggregations().get("maxPrice")).getValue());
client.close();
~~~

分组查询：

~~~java
RestHighLevelClient client = new RestHighLevelClient(RestClient.builder(new HttpHost("192.168.253.132", 9200)));
SearchSourceBuilder searchSourceBuilder = new SearchSourceBuilder();
AggregationBuilder aggregationBuilder = AggregationBuilders.terms("originGroup").field("origin.keyword");
searchSourceBuilder.aggregation(aggregationBuilder);
SearchRequest request = new SearchRequest("cars");
request.source(searchSourceBuilder);
SearchResponse response = client.search(request, RequestOptions.DEFAULT);
ParsedStringTerms terms = response.getAggregations().get("originGroup");
for (Terms.Bucket bucket : terms.getBuckets()) {
    System.out.println(bucket.getKeyAsString() + "：" + bucket.getDocCount());
}
client.close();
~~~



> :horse_racing: 如果需要对大数据量进行聚合，Elasticsearch 提供了`cardinality`和`percentiles`这两种近似聚合算法，它们会提供准确但不是 100% 精确的结果，为我们换来高速的执行效率和极小的内存消耗。



---

#### 9.Elasticsearch 集群

Elasticsearch 集群概念：

1. 分片（Shard）：一个索引可以存储超出单个节点硬件限制的大量数据。而任一节点都可能没有这样大的磁盘空间，为了解决这个问题，Elasticsearch 提供了将索引划分成多份的能力，每一份就称之为分片。

2. 副本（Replicas）：在一个网络/云的环境里，有一个故障转移机制是非常有用并且是强烈推荐的。Elasticsearch 允许创建分片的一份或多份拷贝，这些拷贝叫做副本（一旦创建了拷贝，每个索引就有了主分片和复制分片）。

3. 集群（Cluster）：Elasticsearch 集群是由一个或者多个拥有相同 cluster.name 配置的节点组成，它们共同承担数据和负载的压力。当有节点加入集群中或者从集群中移除节点时，集群将会重新平均分布所有的数据。

   > :ear_of_rice: Elasticsearch 集群健康查看：GET /_cluster/health
   >
   > ~~~json
   > {
   >    "cluster_name":          "elasticsearch",
   >    "status":                "green", 
   >    "timed_out":             false,
   >    "number_of_nodes":       1,
   >    "number_of_data_nodes":  1,
   >    "active_primary_shards": 0,
   >    "active_shards":         0,
   >    "relocating_shards":     0,
   >    "initializing_shards":   0,
   >    "unassigned_shards":     0
   > }
   > ~~~
   >
   > **status** 字段指示着当前集群在总体上是否工作正常。它的三种颜色含义如下：
   >
   > - **`green`**：所有的主分片和副本分片都正常运行。
   > - **`yellow`**：所有的主分片都正常运行，但不是所有的副本分片都正常运行。
   > - **`red`**：有主分片没能正常运行。

4. 节点（Node）：在 Elasticsearch 集群中，每一个单独的 Elasticsearch 服务称为一个节点。

   默认情况下，Elasticsearch 集群节点都是混合节点，即`node.master: true`和`node.data: true`，当集群规模达到一定程度以后，就需要对集群节点进行角色划分，通常我们将Elasticsearch 节点分为主节点、数据节点和客户端节点：

   1. 主节点：`node.master: true`和`node.data: false`，维护元数据，管理集群节点状态，不负责数据写入和查询。
   3. 数据节点：`node.master: false`和`node.data: true`，负责数据的写入与查询。
   4. 客户端节点：`node.master: false`和`node.data: false`，负责任务分发和结果汇聚（类似于负载均衡），分担数据节点压力。



> :bowing_man: 默认情况下创建 Elasticsearch 索引时，Elasticsearch 只会分配 1 个分片和 0 个拷贝，我们也可以在创建索引时添加 RequestBody 内容指定分片和副本数量：
>
> ~~~json
> {
>  "settings": {
>      "number_of_shards": 3,   // 3 个分片
>      "number_of_replicas": 1  // 1 个拷贝
>  }
> }
> ~~~
>
> Elasticsearch 禁止同一个分片的主分片和副本分片在同一个节点上，所以如果是一个节点的集群是不能有副本的。
>
> 分片位置查看请使用：
>
> ~~~http
> http://192.168.253.136:9200/_cat/shards?v
> ~~~



Elasticsearch 集群分配：

1. 单节点集群：当 Elasticsearch 服务只有一个节点时，这一个节点也称为一个集群（单节点集群），在此时创建一个 3 个分片 1 个拷贝的索引时，其分片的分布情况如下：

   ![](../img/elas_0202.png)

   此时 3 个分片都为主分片（副本分片不会被分配），集群的健康状态为`yellow`。

2. 双节点集群（应对故障）：当集群中只有一个节点在运行时，意味着数据没有冗余，不能有效的解决单点故障问题，我们可以再启动一个节点来防止数据丢失。

   如果在同一个机器上启动第二个 Elasticsearch 节点，只要配置了相同的`cluster.name`，节点就可以自动加入集群，但如果使用不同的机器组成集群，则需要两个节点修改相关配置：

   - 主节点配置：

     ~~~yaml
     cluster.name: my-application  # 集群名称
     node.name: node-1             # 节点名称
     path.data: /var/lib/elasticsearch
     path.logs: /var/log/elasticsearch
     network.host: 192.168.253.136 # 暴露 IP（本机 IP）
     cluster.initial_master_nodes: ["node-1"]  # 初始化 master 节点
     discovery.zen.ping.unicast.hosts: ["192.168.253.136:9300", "192.168.253.137:9300", "192.168.253.135:9300"] # 集群广播地址
     ~~~

     > :jack_o_lantern: Elasticsearch 默认使用 9300 端口作为集群节点间的通讯端口。

   - 副节点配置：

     ~~~yaml
     cluster.name: my-application  # 集群名称
     node.name: node-2             # 节点名称
     path.data: /var/lib/elasticsearch
     path.logs: /var/log/elasticsearch
     network.host: 192.168.253.137 # 暴露 IP（本机 IP）
     cluster.initial_master_nodes: ["node-1"]  # 初始化 master 节点
     discovery.zen.ping.unicast.hosts: ["192.168.253.136:9300", "192.168.253.137:9300"] # 集群广播地址
     ~~~

   修改配置后，开启防火墙的 9200、9300 端口，启动 Elasticsearch 服务。

   第 2 个节点加入集群后，Elasticsearch 将会对分片重新分配，此时 3 个主分片和 3 个复制分片均已被分配，其分布情况如下：

   ![](../img/elas_0203.png)

   主分片和复制分片位于不同的节点当中，集群状态为`green`。当集群损失任意一个节点时，数据不会丢失。

3. 三节点集群（水平扩容）：当启动了第三个节点后，Elasticsearch 将会为了分散负载而对分片进行重新分配。

   此时的分片分布如下：

   ![](../img/elas_0204.png)

   此时丢失一个节点不会丢失数据，丢失 2 个节点时也只会丢失 1/3 的数据，我们也可以将`number_of_replicas`调大到 2：

   ~~~json
   PUT /xxx/_settings
   {
      "number_of_replicas" : 2
   }
   ~~~

   ![](D:\GitRepository\HexBook\notes\中间件\分布式服务中间件\Image\elas_0205.png)

   此时就算丢失了 2 个节点，也不会影响集群数据的完整性。

> :dart: 当我们扩容节点时，Elasticsearch 会尽量将分片平均到每一个节点上，这意味着每个节点的硬件资源（CPU, RAM, I/O）将被更少的分片所共享，所以每个分片的性能将会得到提升。
>
> :deciduous_tree: 当我们增加分片的副本数量时，由于读操作可以同时被主分片或副本分片所处理，所以增加分片的副本数量也将拥有更高的吞吐量。



路由计算：当存储数据时，Elasticsearch 会根据文档数据的 Hash 值取主分片数量的余数作为存放数据的主分片的序号，所以在创建索引时就要确定好主分片数量并且不能改变，因为如果数量变化了，那么所有之前路由的值都会无效，文档也再也找不到了。

> :currency_exchange: Elasticsearch 的任意节点都可以作为协调节点（coordinating node）接受请求，然后将请求转发到应该执行请求的节点。



Elasticsearch 写入数据、删除数据流程：

1. 客户端向 Node-1 发送新建、索引或者删除请求。

2. 节点使用文档的 _id 确定文档属于分片 0。请求会被转发到 Node-3，因为分片 0 的主分片目前被分配在 Node-3 上。

3. Node-3 在主分片上面执行请求，成功后将请求并行转发到 Node-1 和 Node-2 的副本分片上。

   > :biking_man: 默认情况下 Elasticsearch 不会等到数据写入到所有副本分片后再向客户端报告成功，它会在数据写入到`int((primary + number_of_replicas)/2) + 1`个副本分片后就向客户端报告成功（此数据可以进行调整）。
   >
   > 如：设定 number_of_replicas 为 2，则计算结果为 int((1 + 2)/2) + 1 = 2。
   >
   > 如果没有足够的副本分片 Elasticsearch 会进行等待，希望更多的分片出现。默认情况下它最多等待1分钟。也可以使用 timeout 参数进行调整。

Elasticsearch 读取数据流程：

1. 客户端向 Node-1 发送获取请求。

2. 节点使用文档的 _id 来确定文档属于分片 0，分片 0 的副本分片存在于所有的三个节点上，在这种情况下，它将请求转发到 Node-2。

3. Node-2 将文档返回给 Node-1，然后将文档返回给客户端。

   > :zap: 在处理读取请求时，协调结点在每次请求的时候都会通过轮询所有的副本分片来达到负载均衡。

Elasticsearch 更新数据流程：

1. 客户端向 Node-1 发送更新请求。

2. 它将请求转发到主分片所在的 Node-3，Node-3 从主分片检索文档，修改 _source 字段中的 JSON，并且尝试重新索引主分片的文档。如果文档已经被另一个进程占用，它会进行重试直到超过 retry_on_conflict 次后放弃。

3. 如果 Node-3 成功地更新文档，它将新版本的文档并行转发到 Node-1 和 Node-2 上的副本分片，重新建立索引。所有副本分片都返回成功再向客户端返回成功。

   > :dango: 当主分片把更改转发到副本分片时，它不会转发更新请求而是转发完整文档的新版本。



> :jeans: 将多节点集群改为单节点集群时，需要删除所有的节点数据（`/var/lib/elasticsearch/nodes`），否则集群不能正常工作。



---

#### 10.Elasticsearch 搜索原理

在搜索工具中为数据建立查询索引是必不可少的步骤，数据索引主要分为 2 种：

1. 正排索引：在向数据库中插入数据时，每一条数据都有一个 ID，以此 ID 作为索引就是正排索引，也是传统的 DBMS 数据库中的索引。
2. 倒排索引：当我们存储以文本形式存在的存储对象时，很多时候我们需要以关键字来进行搜索，这时候我们提取文档中的关键字作为索引，而以文档的 ID 作为值，这样的索引就称为倒排索引。

<u>Elasticsearch 中就使用了倒排索引的原理进行全文检索</u>，例：

文档 001：The quick dog. 

文档 002：The lazy dog.

Elasticsearch 会将文档内容拆分为词条，创建一个包含所有不重复词条的排序列表，然后列出每个词条出现在哪个文档：

| Term  | Doc_001 | Doc_002 | Doc_... |
| ----- | ------- | ------- | ------- |
| The   | √       | √       | ...     |
| quick | √       |         | ...     |
| dog   | √       | √       | ...     |
| lazy  |         | √       | ...     |

例如搜索 The quick，两个 Doc 都会被匹配到，但 Doc_001 的匹配度更高。

> :eggplant: Elasticsearch 内置了分词器对文档进行分词处理，还包括过滤字符，大小写转换等：
>
> - 词条：索引中最小存储和查询单元。
> - 词典：词条的集合，Elasticsearch 中使用 B+ Tree。
> - 倒排表：倒排索引与<u>文档 ID、单词出现的位置信息</u>的对应关系表。
>
> 注意：默认分词器不支持中文分词，需要自行安装 ik 分词器。



在 Lucene 中，为了实现高索引速度，使用了 Segment 分段（Lucene 中单个倒排索引文件被称为`Segment`）架构存储，数据的存储步骤为：

1. 客户端传入新的文档数据（一个或多个），Elasticsearch 将其写入到内存缓存中。

2. 每隔 1s 时间（可配置），Elasticsearch 将打开一个新的 Segment 并将内存缓存中的数据 refresh 到这个新的 segment 中，此时这一部分数据对搜索可见（这就是 Elasticsearch 近实时搜索的原因）。

   每一个 Segment 中都维护了一个 .del 文件，如果是删除数据，也是在新的分段中的 .del 文件中加入已删除文档的信息；如果是更新文档，则是删除旧的文档，在新的 Segment 中加入更新后的新版本文档数据。

   > :japanese_ogre: 由于 Segment 是位于内存当中，如果断电会产生数据丢失，所以 Elasticsearch 采用 translog（事务日志）来记录每一次对 Elasticsearch 的操作，如果发生了故障则可以通过 translog 来恢复数据。

3. 每隔一段时间（默认 30 分钟）或者 translog 变得越来越大时，Elasticsearch 就会启动 flush 操作，创建一个 Commit point，将所有已知的段持久化到磁盘当中并删除旧的 translog。

   

**段合并**：由于每秒钟 refresh 都会产生一个新的 segment（段），段数量过多会导致过多的消耗文件句柄、内存和 CPU 时间，影响查询速度。基于这个原因，Lucene 通过合并段来解决这个问题，即将一小部分大小相似的段合并为一个更大的段：

![](../img/elas_1110.png)

如图：段合并将两个已经提交了的段和一个没有提交的段合并为了一个更大的段，合并时已删除的文档不会被合并到大的分段当中。

![](../img/elas_1111.png)

合并完成后，老的段被删除，新的段被 flush 到磁盘。

> :articulated_lorry: Elasticsearch 按段搜索：当一个查询被触发，Elasticsearch 将会查询所有已知的段然后对所有段的结果进行聚合并计算结果。



---

#### 10.SpringData 框架集成

使用 SpringBoot 的方式加入 Elasticsearch 依赖并进行配置。



1. 配置集群地址：

   ~~~properties
   # Elasticsearch 配置
   spring.elasticsearch.rest.uris=http://192.168.253.136:9200
   ~~~

2. 新建实体类与 Index 相对应：

   ~~~java
   @Data
   @Accessors(chain = true)
   @Document(indexName = "score")
   public class Score {
       @Id
       private long id;
       @Field(type = FieldType.Keyword)
       private String name;
       @Field(type = FieldType.Integer_Range)
       private int chinese;
       @Field(type = FieldType.Integer_Range)
       private int math;
       @Field(type = FieldType.Integer_Range)
       private int english;
       @Field(type = FieldType.Integer_Range)
       private int total;
   }
   ~~~

   配置完成后，就可使用 Spring 提供的相关组件对 Elasticsearch 数据进行相关操作。

> :dark_sunglasses: SpringBoot 应用启动后会扫描应用中的实体类，创建缺省的索引。



操作 Elasticsearch 数据：

1. 使用 ElasticsearchRestTemplate：向应用组件注入 ElasticsearchRestTemplate 便可进行操作。

   ~~~java
   @Autowired
   private ElasticsearchRestTemplate template;
   
   @Test
   void contextLoads() {
       Score s = template.get("0", Score.class, IndexCoordinates.of("score"));
       System.out.println(s);
   }
   
   @Test
   void findByPage() {
       Sort sort = Sort.by(Sort.Direction.DESC,"chinese");
       // 每页 3 个，第一页
       PageRequest pageRequest = PageRequest.of(0, 3, sort);
       for (Score score : dao.findAll(pageRequest)) {
           System.out.println(score);
       }
   }
   ~~~

2. 使用 SpringBoot 内置的 Repository 进行默认操作：

   ~~~java
   @Repository
   public interface ScoreDao extends ElasticsearchRepository<Score, Long> {
   }
   ~~~

   此接口后指定 Elasticsearch 中使用 Long 作为对象 ID，创建此接口后便可进行 Elasticsearch 的一部分基础操作。除此之外，还可以在 ScoreDao 中定义其他方法以执行其他操作（不需要实现）：

   ~~~java
   @Repository
   public interface ScoreDao extends ElasticsearchRepository<Score, Long> {
       Score findByName(String name);
   }
   ~~~

   

---

#### 11.Elasticsearch 优化

:carousel_horse: 硬件选择

Elasticsearch 所有的索引和文档数据是存储在本地的磁盘中，具体的路径可在 ES 的配置文件 elasticsearch.yml 中进行配置：

~~~yaml
path.data: /var/lib/elasticsearch
path.logs: /var/log/elasticsearch
~~~

Elasticsearch 重度使用磁盘，磁盘能处理的吞吐量越大，节点就越稳定。优化磁盘 I/O 的技巧如下：

1. 使用 SSD（固态硬盘）代替机械硬盘。
2. 使用磁盘阵列提高磁盘的 I/O 性能。
3. 不要使用远程挂载的存储，其引入的延迟对性能来说完全是背道而驰的。



:dragon_face: 分片策略：分片和副本的设计为 Elasticsearch 提供了支持分布式和故障转移的特性，但并不意味着分片和副本是可以无限分配的。而且索引的分片完成分配后由于索引的路由机制，我们是不能重新修改分片数的。

过多的分片会导致以下后果：

1. 一个分片的底层即为一个 Lucene 索引，会消耗一定文件句柄、内存、以及 CPU 运转。
2. 每一个搜索请求都需要命中索引中的一些分片，如果每一个分片都处于不同的节点还好，但如果多个分片都需要在同一个节点上就会竞争使用相同的资源。
3. 用于计算相关度的词项统计信息是基于分片的，如果有许多分片，每一个都只有很少的数据会导致很低的相关度。

一个业务索引具体需要分配多少分片可能需要架构师和技术人员对业务的增长有个预先的判断，然后遵循以下规则进行分配：

1. 控制每个分片占用的硬盘容量不超过 Elasticsearch 的最大 JVM 的堆空间设置（在`jvm.options`文件中查看）。例：如过索引的总容量在 10G 左右，最大堆内存设置为 4G，那么分片大小数量为 3 较为合适。

   > :derelict_house: 注意：任何情况下每个分片的容量不得超过 31-32G（临界值）。

2. 分片数不超过节点数的 3 倍，否则一个节点上存在过多的分片，会加大数据丢失的风险。

3. 主分片，副本和节点最大数之间数量可以参考以下关系：`节点数 <= 主分片数 *（副本数 + 1）`。

   

:desert_island: 其他设置：

1. 推迟分片分配：当节点中断时，集群默认会等待一分钟来查看节点是否会重新加入，超过这个时间后才会触发新的分片分配。这样就可以减少 ES 在自动再平衡可用分片时所带来的极大开销。通过修改参数`delayed_timeout`，可以延长这个时间，可以全局设置也可以在索引级别进行修改:

   ~~~json
   PUT /_all/_settings 
   {
     "settings": {
       "index.unassigned.node_left.delayed_timeout": "5m" 
     }
   }
   ~~~

2. 根据业务规则选择路由：默认情况下，Elasticsearch 使用文档 ID 进行 Hash 计算数据的分片序号。

   但是在实际使用中，很多时候我们使用关键字而不是文档的 ID 进行查询，这样 Elasticsearch 就会对每一个分片都进行查询然后聚合结果。

   通过修改路由规则（例如使用文档某个字段名进行路由），在查询时就只会命中特定的分片而不是对所有分片都进行查询。



:elephant: 写入速度的优化：Elasticsearch 的默认配置是综合了数据可靠性、写入速度、搜索实时性等因素。实际使用时，我们需要根据公司要求，进行偏向性的优化。针对于搜索性能要求不高，但是对写入要求较高的场景，我们需要尽可能的选择恰当写优化策略：

1. 加大 Translog 日志`index.translog.flush_threshold_size`触发 flush 的临界值大小和自动 flush 的间隔时间`index.translog.flush_threshold_period`。

2. 增加 Refresh 间隔，这样就能减少 Segment Merge（段合并）的次数从而减少 I/O 开销（按索引进行设置）：

   ~~~json
   PUT /my_logs/_settings
   {
   	"index": {
   		"refresh_interval": "1s"
   	}
   }
   ~~~

3. 批量数据提交：Elasticsearch 使用 Bulk 线程池和队列来进行批量数据的写入，默认情况下批量提交的数据量不能超过 100M。数据条数一般根据文档的大小和服务器性能而定的，实际使用中单次批处理的数据应从 5MB～15MB 中进行测试然后选择性能更好的数据大小（最好不要超过15MB）。

4. 优化节点间的任务分布：节点数较多时，将节点分为主节点、数据节点和客户端节点进行更合理的任务分配。

5. 减少副本的数量：写入数据时，需要把写入的数据都同步到副本节点，副本节点越多，写索引的效率就越慢。在保证数据安全的情况下尽量使用更是的副本数量，同时，在大批量写入数据之前，调整`index.number_of_replicas: 0`禁用副本提高写入效率，过后再修改回来同步数据。



:hear_no_evil: 内存分配：Elasticsearch 的内存设置定义在安装文件 jvm.option 中。

1. 确保堆内存 Xmx 和 Xms 的大小是相同的，其目的是为了能够在 Java 垃圾回收机制清理完堆区后不需要重新分隔计算堆区的大小而浪费资源，可以减轻伸缩堆大小带来的压力。
2. 堆内存最大不要超过物理内存的 50%，因为 Lucene 的设计目的是把底层 OS 里的数据缓存到内存中，如果 Elasticsearch 占用的内存过大，那么底层能利用的系统内存就会偏小从而影响查询性能。
3. 堆内存的大小最好不要超过 32GB，超过这个值后，内存寻址的指针就会偏大，导致查询性能下降，硬件资源足够的情况下，可以设置为 31G。



---

#### 12.相关面试题

常见的 Elasticsearch 使用场景？
系统中的数据常常需要采用模糊查询进行数据的搜索，而模糊查询会导致传统的数据库放弃索引进行全表扫描，查询效率非常低下的，我们使用 Elasticsearch 做一个全文索引，将经常查询的系统功能的某些字段放入 Elasticsearch 索引库里，通过 Elasticsearch 查询出 ID，再去数据库中查询具体的数据。



Elasticsearch 集群脑裂问题？

集群脑裂：集群中的节点在选择主节点上出现分歧导致一个集群出现多个主节点从而使集群分裂，使得集群处于异常状态。

脑裂问题产生原因：

1. 网络： 集群间的网络延迟导致一些节点访问不到 master，认为 master 挂掉从而选举出新的 master（内网一般不会出现此问题）。
2. 节点负载： 由于 master 节点与 data 节点都是混合在一起的， 所以当节点的负载较大时， 导致对应的 Elasticsearch 实例停止响应，那么一部分节点就会认为这个 master 节点失效了，故重新选举新的节点。
3. 内存回收：由于 data 节点上 es 进程占用的内存较大，较大规模的内存回收操作也可能造成 Elasticsearch 进程失去响应。

脑裂问题解决办法：

1. 调大参数`discovery.zen.ping_timeout`，可适当减少网络延迟导致的误判。
2. 角色分离：将 master 节点与 data 节点分离，可以防止节点负载和内存回收导致的 Elasticsearch 进程失去响应。
3. 选举触发条件：默认情况下 Elasticsearch 设置的`discovery.zen.minimum_master_nodes`的值为 1，将其设置为`int(nodes/2) + 1`，即节点至少被一半以上的节点投票才能成为主节点。



在并发情况下，Elasticsearch 如何保证读写一致？

1. Elasticsearch 通过版本号使用乐观锁进行并发控制，以确保新版本不会被旧版本覆盖，由应用层来处理具体的冲突。

2. 对于写操作，一致性级别支持 quorum/one/all，默认为 quorum，即只有当大多数分片可用时才允许写操作。
3. 在写的过程中如果因为网络等原因导致写入副本失败，这样该副本被认为故障，分片将会在一个不同的节点上重建。
4. 对于读操作，可以设置 replication 为 sync（默认），这使得写操作在主分片和副本分片都完成后才会返回。
5. 如果设置 replication 为 async 时，也可以通过设置搜索请求参数 _preference 为 primary 来强制查询主分片，确保文档是最新版本。