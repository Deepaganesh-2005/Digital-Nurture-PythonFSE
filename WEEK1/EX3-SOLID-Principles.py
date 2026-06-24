from abc import ABC, abstractmethod

# LIBRARY MANAGEMENT SYSTEM IMPLEMENTING SOLID PRINCIPLES

class Book:
    def __init__(self, title, author):
        self.title = title
        self.author = author


class LibraryCatalog:
    def add_book(self, book):
        print(f"Book Added: {book.title}")


class BookIssueService:
    def issue_book(self, book):
        print(f"Book Issued: {book.title}")


class BookReturnService:
    def return_book(self, book):
        print(f"Book Returned: {book.title}")


class Notification(ABC):
    @abstractmethod
    def send_notification(self, message):
        pass


class EmailNotification(Notification):
    def send_notification(self, message):
        print(f"Email Notification: {message}")


class SMSNotification(Notification):
    def send_notification(self, message):
        print(f"SMS Notification: {message}")


class PushNotification(Notification):
    def send_notification(self, message):
        print(f"Push Notification: {message}")


class BookSearcher(ABC):
    @abstractmethod
    def search_book(self, title):
        pass


class BookReporter(ABC):
    @abstractmethod
    def generate_report(self):
        pass


class LibrarySearch(BookSearcher):
    def search_book(self, title):
        print(f"Searching for book: {title}")


class LibraryReport(BookReporter):
    def generate_report(self):
        print("Generating Library Report")


class LibraryManagementService:
    def __init__(self, notification_service: Notification):
        self.notification_service = notification_service

    def issue_book(self, book):
        print(f"Issuing book: {book.title}")
        self.notification_service.send_notification(
            f"{book.title} has been issued successfully"
        )


book = Book("Clean Code", "Robert C. Martin")

catalog = LibraryCatalog()
catalog.add_book(book)

issue_service = BookIssueService()
issue_service.issue_book(book)

return_service = BookReturnService()
return_service.return_book(book)

search_service = LibrarySearch()
search_service.search_book("Clean Code")

report_service = LibraryReport()
report_service.generate_report()

notification = EmailNotification()

library_service = LibraryManagementService(notification)
library_service.issue_book(book)