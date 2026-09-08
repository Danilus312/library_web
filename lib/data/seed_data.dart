import '../models/author.dart';
import '../models/book.dart';

final List<Author> seedAuthors = [
  const Author(id: 1, firstName: 'Лев', lastName: 'Толстой', country: 'Россия', birthYear: 1828),
  const Author(id: 2, firstName: 'Фёдор', lastName: 'Достоевский', country: 'Россия', birthYear: 1821),
  const Author(id: 3, firstName: 'Джордж', lastName: 'Оруэлл', country: 'Великобритания', birthYear: 1903),
  const Author(id: 4, firstName: 'Михаил', lastName: 'Булгаков', country: 'Россия', birthYear: 1891),
  const Author(id: 5, firstName: 'Рэй', lastName: 'Брэдбери', country: 'США', birthYear: 1920),
  const Author(id: 6, firstName: 'Франц', lastName: 'Кафка', country: 'Австрия', birthYear: 1883),
  const Author(id: 7, firstName: 'Габриэль', lastName: 'Гарсиа Маркес', country: 'Колумбия', birthYear: 1927),
  const Author(id: 8, firstName: 'Антон', lastName: 'Чехов', country: 'Россия', birthYear: 1860),
  const Author(id: 9, firstName: 'Эрих Мария', lastName: 'Ремарк', country: 'Германия', birthYear: 1898),
  const Author(id: 10, firstName: 'Харуки', lastName: 'Мураками', country: 'Япония', birthYear: 1949),
];

final List<Book> seedBooks = [
  const Book(id: 1, title: 'Война и мир', isbn: '978-5-389-06256-6', year: 1869, pages: 1225, publisherId: 1, authorIds: [1], genreIds: [1, 2], copiesTotal: 5, copiesAvailable: 3),
  const Book(id: 2, title: 'Анна Каренина', isbn: '978-5-17-090635-2', year: 1877, pages: 864, publisherId: 1, authorIds: [1], genreIds: [1], copiesTotal: 4, copiesAvailable: 2),
  const Book(id: 3, title: 'Преступление и наказание', isbn: '978-5-389-07446-0', year: 1866, pages: 672, publisherId: 2, authorIds: [2], genreIds: [1, 3], copiesTotal: 7, copiesAvailable: 5),
  const Book(id: 4, title: 'Идиот', isbn: '978-5-17-080088-9', year: 1869, pages: 640, publisherId: 2, authorIds: [2], genreIds: [1], copiesTotal: 3, copiesAvailable: 1),
  const Book(id: 5, title: 'Братья Карамазовы', isbn: '978-5-389-04922-2', year: 1880, pages: 840, publisherId: 2, authorIds: [2], genreIds: [1, 3], copiesTotal: 6, copiesAvailable: 4),
  const Book(id: 6, title: '1984', isbn: '978-5-17-080115-2', year: 1949, pages: 320, publisherId: 3, authorIds: [3], genreIds: [4, 5], copiesTotal: 10, copiesAvailable: 8),
  const Book(id: 7, title: 'Скотный двор', isbn: '978-5-17-092588-9', year: 1945, pages: 160, publisherId: 3, authorIds: [3], genreIds: [4, 6], copiesTotal: 8, copiesAvailable: 6),
  const Book(id: 8, title: 'Мастер и Маргарита', isbn: '978-5-389-01686-6', year: 1967, pages: 512, publisherId: 1, authorIds: [4], genreIds: [1, 7], copiesTotal: 9, copiesAvailable: 7),
  const Book(id: 9, title: 'Белая гвардия', isbn: '978-5-17-083422-8', year: 1925, pages: 384, publisherId: 1, authorIds: [4], genreIds: [1, 2], copiesTotal: 4, copiesAvailable: 2),
  const Book(id: 10, title: '451 градус по Фаренгейту', isbn: '978-5-17-077750-1', year: 1953, pages: 256, publisherId: 3, authorIds: [5], genreIds: [4, 5], copiesTotal: 12, copiesAvailable: 9),
  const Book(id: 11, title: 'Марсианские хроники', isbn: '978-5-17-086555-0', year: 1950, pages: 352, publisherId: 3, authorIds: [5], genreIds: [5], copiesTotal: 5, copiesAvailable: 3),
  const Book(id: 12, title: 'Процесс', isbn: '978-5-17-080055-1', year: 1925, pages: 288, publisherId: 2, authorIds: [6], genreIds: [1, 3], copiesTotal: 4, copiesAvailable: 3),
  const Book(id: 13, title: 'Превращение', isbn: '978-5-389-05544-5', year: 1915, pages: 192, publisherId: 2, authorIds: [6], genreIds: [1, 7], copiesTotal: 6, copiesAvailable: 4),
  const Book(id: 14, title: 'Сто лет одиночества', isbn: '978-5-17-087088-2', year: 1967, pages: 480, publisherId: 1, authorIds: [7], genreIds: [1, 7], copiesTotal: 7, copiesAvailable: 2),
  const Book(id: 15, title: 'Вишнёвый сад', isbn: '978-5-389-02234-8', year: 1904, pages: 96, publisherId: 1, authorIds: [8], genreIds: [8], copiesTotal: 5, copiesAvailable: 5),
  const Book(id: 16, title: 'Палата №6', isbn: '978-5-17-094112-4', year: 1892, pages: 128, publisherId: 1, authorIds: [8], genreIds: [1], copiesTotal: 6, copiesAvailable: 4),
  const Book(id: 17, title: 'На Западном фронте без перемен', isbn: '978-5-17-084224-7', year: 1929, pages: 288, publisherId: 2, authorIds: [9], genreIds: [1, 2], copiesTotal: 8, copiesAvailable: 5),
  const Book(id: 18, title: 'Три товарища', isbn: '978-5-17-080112-1', year: 1936, pages: 480, publisherId: 2, authorIds: [9], genreIds: [1], copiesTotal: 11, copiesAvailable: 8),
  const Book(id: 19, title: 'Триумфальная арка', isbn: '978-5-17-082555-4', year: 1945, pages: 544, publisherId: 2, authorIds: [9], genreIds: [1], copiesTotal: 6, copiesAvailable: 3),
  const Book(id: 20, title: 'Норвежский лес', isbn: '978-5-04-098889-1', year: 1987, pages: 384, publisherId: 3, authorIds: [10], genreIds: [1], copiesTotal: 7, copiesAvailable: 6),
  const Book(id: 21, title: 'Кафка на пляже', isbn: '978-5-04-102334-8', year: 2002, pages: 640, publisherId: 3, authorIds: [10], genreIds: [1, 7], copiesTotal: 5, copiesAvailable: 2),
];

const Map<int, String> genreMap = {
  1: 'Классика',
  2: 'Исторический',
  3: 'Философия',
  4: 'Антиутопия',
  5: 'Фантастика',
  6: 'Сатира',
  7: 'Магический реализм',
  8: 'Драматургия',
};

const Map<int, String> publisherMap = {
  1: 'Азбука-Аттикус',
  2: 'Эксмо',
  3: 'АСТ',
};