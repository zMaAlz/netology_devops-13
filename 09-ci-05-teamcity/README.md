# Домашнее задание к занятию "09.05 Teamcity"

## Создайте новый проект в teamcity на основе fork
1. Сделайте autodetect конфигурации
2. Сохраните необходимые шаги, запустите первую сборку master'a
3. Поменяйте условия сборки: если сборка по ветке master, то должен 
4. происходит mvn clean deploy, иначе mvn clean test
5. Для deploy будет необходимо загрузить settings.xml в набор конфигураций maven у teamcity, предварительно записав туда креды для подключения к nexus
6. В pom.xml необходимо поменять ссылки на репозиторий и nexus
7. Запустите сборку по master, убедитесь что всё прошло успешно, артефакт появился в nexus
8. Мигрируйте build configuration в репозиторий
9. Создайте отдельную ветку feature/add_reply в репозитории
10. Напишите новый метод для класса Welcomer: метод должен возвращать произвольную реплику, содержащую слово hunter
11. Дополните тест для нового метода на поиск слова hunter в новой реплике
12. Сделайте push всех изменений в новую ветку в репозиторий
13. Убедитесь что сборка самостоятельно запустилась, тесты прошли успешно
14. Внесите изменения из произвольной ветки feature/add_reply в master через Merge
15. Настройте конфигурацию так, чтобы она собирала .jar в артефакты сборки
16. Проведите повторную сборку мастера, убедитесь, что сбора прошла успешно и артефакты собраны
17. Проверьте, что конфигурация в репозитории содержит все настройки конфигурации из teamcity
18. В ответ предоставьте ссылку на репозиторий

[Решение](https://github.com/zMaAlz/example-teamcity)