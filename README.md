# Monitoring Jenkins using Metrics Plugin and Zabbix

## This solution is composed by three parts
 1. [Metrics Jenkins Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Metrics+Plugin)
 2. A python script, which gets metrics from above plugin and transform it in a readable Zabbix item.
 3. A Zabbix Agentd config file which runs the above script and sends result to  Zabbix server

## Installing
1. First install [Metrics Jenkins Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Metrics+Plugin) and create a access key.
2. Put Jenkins’ URL and access key into `jenkins-metrics.py`
3. Move `jenkins-metrics.py` and `jenkins_zabbix.conf` to Jenkins master instance.
4. Now take another look at [Metrics Jenkins Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Metrics+Plugin) to know more about these metrics and start creating items in Zabbix server

---

## Appendix
### How this python script works
It simply uses [Metrics Jenkins Plugin](https://wiki.jenkins-ci.org/display/JENKINS/Metrics+Plugin)’s API to get a Json containing metrics and transforms it in a more readable file to Zabbix.

However you can also make use of it without a Zabbix, like shown bellow:

```
python jenkins-metrics.py
```

This will return all the metrics at once

If you want to get just one of the metrics, use a full path to a metric item. For example, to get this metric

```
{
  "gauges" : {
    "jenkins.executor.count.value" : {
      "value" : 52
    },
...
```
 
You can type:

```
python jenkins-metrics.py gauges.jenkins.executor.count.value.value
```
