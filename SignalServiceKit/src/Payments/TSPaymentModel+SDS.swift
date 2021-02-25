//
//  Copyright (c) 2021 Open Whisper Systems. All rights reserved.
//

import Foundation
import GRDB
import SignalCoreKit

// NOTE: This file is generated by /Scripts/sds_codegen/sds_generate.py.
// Do not manually edit it, instead run `sds_codegen.sh`.

// MARK: - Record

public struct PaymentModelRecord: SDSRecord {
    public weak var delegate: SDSRecordDelegate?

    public var tableMetadata: SDSTableMetadata {
        return TSPaymentModelSerializer.table
    }

    public static let databaseTableName: String = TSPaymentModelSerializer.table.tableName

    public var id: Int64?

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    public let recordType: SDSRecordType
    public let uniqueId: String

    // Properties
    public let addressUuidString: String?
    public let createdTimestamp: UInt64
    public let isUnread: Bool
    public let mcIncomingTransaction: Data?
    public let mcLedgerBlockIndex: UInt64
    public let memoMessage: String?
    public let mobileCoin: Data?
    public let notificationMessageUniqueId: String?
    public let paymentAmount: Data?
    public let paymentFailure: TSPaymentFailure
    public let paymentState: TSPaymentState
    public let paymentType: TSPaymentType
    public let requestUuidString: String?

    public enum CodingKeys: String, CodingKey, ColumnExpression, CaseIterable {
        case id
        case recordType
        case uniqueId
        case addressUuidString
        case createdTimestamp
        case isUnread
        case mcIncomingTransaction
        case mcLedgerBlockIndex
        case memoMessage
        case mobileCoin
        case notificationMessageUniqueId
        case paymentAmount
        case paymentFailure
        case paymentState
        case paymentType
        case requestUuidString
    }

    public static func columnName(_ column: PaymentModelRecord.CodingKeys, fullyQualified: Bool = false) -> String {
        return fullyQualified ? "\(databaseTableName).\(column.rawValue)" : column.rawValue
    }

    public func didInsert(with rowID: Int64, for column: String?) {
        guard let delegate = delegate else {
            owsFailDebug("Missing delegate.")
            return
        }
        delegate.updateRowId(rowID)
    }
}

// MARK: - Row Initializer

public extension PaymentModelRecord {
    static var databaseSelection: [SQLSelectable] {
        return CodingKeys.allCases
    }

    init(row: Row) {
        id = row[0]
        recordType = row[1]
        uniqueId = row[2]
        addressUuidString = row[3]
        createdTimestamp = row[4]
        isUnread = row[5]
        mcIncomingTransaction = row[6]
        mcLedgerBlockIndex = row[7]
        memoMessage = row[8]
        mobileCoin = row[9]
        notificationMessageUniqueId = row[10]
        paymentAmount = row[11]
        paymentFailure = row[12]
        paymentState = row[13]
        paymentType = row[14]
        requestUuidString = row[15]
    }
}

// MARK: - StringInterpolation

public extension String.StringInterpolation {
    mutating func appendInterpolation(paymentModelColumn column: PaymentModelRecord.CodingKeys) {
        appendLiteral(PaymentModelRecord.columnName(column))
    }
    mutating func appendInterpolation(paymentModelColumnFullyQualified column: PaymentModelRecord.CodingKeys) {
        appendLiteral(PaymentModelRecord.columnName(column, fullyQualified: true))
    }
}

// MARK: - Deserialization

// TODO: Rework metadata to not include, for example, columns, column indices.
extension TSPaymentModel {
    // This method defines how to deserialize a model, given a
    // database row.  The recordType column is used to determine
    // the corresponding model class.
    class func fromRecord(_ record: PaymentModelRecord) throws -> TSPaymentModel {

        guard let recordId = record.id else {
            throw SDSError.invalidValue
        }

        switch record.recordType {
        case .paymentModel:

            let uniqueId: String = record.uniqueId
            let addressUuidString: String? = record.addressUuidString
            let createdTimestamp: UInt64 = record.createdTimestamp
            let isUnread: Bool = record.isUnread
            let mcIncomingTransaction: Data? = SDSDeserialization.optionalData(record.mcIncomingTransaction, name: "mcIncomingTransaction")
            let mcLedgerBlockIndex: UInt64 = record.mcLedgerBlockIndex
            let memoMessage: String? = record.memoMessage
            let mobileCoinSerialized: Data? = record.mobileCoin
            let mobileCoin: MobileCoinPayment? = try SDSDeserialization.optionalUnarchive(mobileCoinSerialized, name: "mobileCoin")
            let notificationMessageUniqueId: String? = record.notificationMessageUniqueId
            let paymentAmountSerialized: Data? = record.paymentAmount
            let paymentAmount: TSPaymentAmount? = try SDSDeserialization.optionalUnarchive(paymentAmountSerialized, name: "paymentAmount")
            let paymentFailure: TSPaymentFailure = record.paymentFailure
            let paymentState: TSPaymentState = record.paymentState
            let paymentType: TSPaymentType = record.paymentType
            let requestUuidString: String? = record.requestUuidString

            return TSPaymentModel(grdbId: recordId,
                                  uniqueId: uniqueId,
                                  addressUuidString: addressUuidString,
                                  createdTimestamp: createdTimestamp,
                                  isUnread: isUnread,
                                  mcIncomingTransaction: mcIncomingTransaction,
                                  mcLedgerBlockIndex: mcLedgerBlockIndex,
                                  memoMessage: memoMessage,
                                  mobileCoin: mobileCoin,
                                  notificationMessageUniqueId: notificationMessageUniqueId,
                                  paymentAmount: paymentAmount,
                                  paymentFailure: paymentFailure,
                                  paymentState: paymentState,
                                  paymentType: paymentType,
                                  requestUuidString: requestUuidString)

        default:
            owsFailDebug("Unexpected record type: \(record.recordType)")
            throw SDSError.invalidValue
        }
    }
}

// MARK: - SDSModel

extension TSPaymentModel: SDSModel {
    public var serializer: SDSSerializer {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        switch self {
        default:
            return TSPaymentModelSerializer(model: self)
        }
    }

    public func asRecord() throws -> SDSRecord {
        return try serializer.asRecord()
    }

    public var sdsTableName: String {
        return PaymentModelRecord.databaseTableName
    }

    public static var table: SDSTableMetadata {
        return TSPaymentModelSerializer.table
    }
}

// MARK: - DeepCopyable

extension TSPaymentModel: DeepCopyable {

    public func deepCopy() throws -> AnyObject {
        // Any subclass can be cast to it's superclass,
        // so the order of this switch statement matters.
        // We need to do a "depth first" search by type.
        guard let id = self.grdbId?.int64Value else {
            throw OWSAssertionError("Model missing grdbId.")
        }

        do {
            let modelToCopy = self
            assert(type(of: modelToCopy) == TSPaymentModel.self)
            let uniqueId: String = modelToCopy.uniqueId
            let addressUuidString: String? = modelToCopy.addressUuidString
            let createdTimestamp: UInt64 = modelToCopy.createdTimestamp
            let isUnread: Bool = modelToCopy.isUnread
            let mcIncomingTransaction: Data? = modelToCopy.mcIncomingTransaction
            let mcLedgerBlockIndex: UInt64 = modelToCopy.mcLedgerBlockIndex
            let memoMessage: String? = modelToCopy.memoMessage
            // NOTE: If this generates build errors, you made need to
            // modify DeepCopy.swift to support this type.
            //
            // That might mean:
            //
            // * Implement DeepCopyable for this type (e.g. a model).
            // * Modify DeepCopies.deepCopy() to support this type (e.g. a collection).
            let mobileCoin: MobileCoinPayment?
            if let mobileCoinForCopy = modelToCopy.mobileCoin {
               mobileCoin = try DeepCopies.deepCopy(mobileCoinForCopy)
            } else {
               mobileCoin = nil
            }
            let notificationMessageUniqueId: String? = modelToCopy.notificationMessageUniqueId
            // NOTE: If this generates build errors, you made need to
            // modify DeepCopy.swift to support this type.
            //
            // That might mean:
            //
            // * Implement DeepCopyable for this type (e.g. a model).
            // * Modify DeepCopies.deepCopy() to support this type (e.g. a collection).
            let paymentAmount: TSPaymentAmount?
            if let paymentAmountForCopy = modelToCopy.paymentAmount {
               paymentAmount = try DeepCopies.deepCopy(paymentAmountForCopy)
            } else {
               paymentAmount = nil
            }
            let paymentFailure: TSPaymentFailure = modelToCopy.paymentFailure
            let paymentState: TSPaymentState = modelToCopy.paymentState
            let paymentType: TSPaymentType = modelToCopy.paymentType
            let requestUuidString: String? = modelToCopy.requestUuidString

            return TSPaymentModel(grdbId: id,
                                  uniqueId: uniqueId,
                                  addressUuidString: addressUuidString,
                                  createdTimestamp: createdTimestamp,
                                  isUnread: isUnread,
                                  mcIncomingTransaction: mcIncomingTransaction,
                                  mcLedgerBlockIndex: mcLedgerBlockIndex,
                                  memoMessage: memoMessage,
                                  mobileCoin: mobileCoin,
                                  notificationMessageUniqueId: notificationMessageUniqueId,
                                  paymentAmount: paymentAmount,
                                  paymentFailure: paymentFailure,
                                  paymentState: paymentState,
                                  paymentType: paymentType,
                                  requestUuidString: requestUuidString)
        }

    }
}

// MARK: - Table Metadata

extension TSPaymentModelSerializer {

    // This defines all of the columns used in the table
    // where this model (and any subclasses) are persisted.
    static let idColumn = SDSColumnMetadata(columnName: "id", columnType: .primaryKey)
    static let recordTypeColumn = SDSColumnMetadata(columnName: "recordType", columnType: .int64)
    static let uniqueIdColumn = SDSColumnMetadata(columnName: "uniqueId", columnType: .unicodeString, isUnique: true)
    // Properties
    static let addressUuidStringColumn = SDSColumnMetadata(columnName: "addressUuidString", columnType: .unicodeString, isOptional: true)
    static let createdTimestampColumn = SDSColumnMetadata(columnName: "createdTimestamp", columnType: .int64)
    static let isUnreadColumn = SDSColumnMetadata(columnName: "isUnread", columnType: .int)
    static let mcIncomingTransactionColumn = SDSColumnMetadata(columnName: "mcIncomingTransaction", columnType: .blob, isOptional: true)
    static let mcLedgerBlockIndexColumn = SDSColumnMetadata(columnName: "mcLedgerBlockIndex", columnType: .int64)
    static let memoMessageColumn = SDSColumnMetadata(columnName: "memoMessage", columnType: .unicodeString, isOptional: true)
    static let mobileCoinColumn = SDSColumnMetadata(columnName: "mobileCoin", columnType: .blob, isOptional: true)
    static let notificationMessageUniqueIdColumn = SDSColumnMetadata(columnName: "notificationMessageUniqueId", columnType: .unicodeString, isOptional: true)
    static let paymentAmountColumn = SDSColumnMetadata(columnName: "paymentAmount", columnType: .blob, isOptional: true)
    static let paymentFailureColumn = SDSColumnMetadata(columnName: "paymentFailure", columnType: .int)
    static let paymentStateColumn = SDSColumnMetadata(columnName: "paymentState", columnType: .int)
    static let paymentTypeColumn = SDSColumnMetadata(columnName: "paymentType", columnType: .int)
    static let requestUuidStringColumn = SDSColumnMetadata(columnName: "requestUuidString", columnType: .unicodeString, isOptional: true)

    // TODO: We should decide on a naming convention for
    //       tables that store models.
    public static let table = SDSTableMetadata(collection: TSPaymentModel.collection(),
                                               tableName: "model_TSPaymentModel",
                                               columns: [
        idColumn,
        recordTypeColumn,
        uniqueIdColumn,
        addressUuidStringColumn,
        createdTimestampColumn,
        isUnreadColumn,
        mcIncomingTransactionColumn,
        mcLedgerBlockIndexColumn,
        memoMessageColumn,
        mobileCoinColumn,
        notificationMessageUniqueIdColumn,
        paymentAmountColumn,
        paymentFailureColumn,
        paymentStateColumn,
        paymentTypeColumn,
        requestUuidStringColumn
        ])
}

// MARK: - Save/Remove/Update

@objc
public extension TSPaymentModel {
    func anyInsert(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .insert, transaction: transaction)
    }

    // Avoid this method whenever feasible.
    //
    // If the record has previously been saved, this method does an overwriting
    // update of the corresponding row, otherwise if it's a new record, this
    // method inserts a new row.
    //
    // For performance, when possible, you should explicitly specify whether
    // you are inserting or updating rather than calling this method.
    func anyUpsert(transaction: SDSAnyWriteTransaction) {
        let isInserting: Bool
        if TSPaymentModel.anyFetch(uniqueId: uniqueId, transaction: transaction) != nil {
            isInserting = false
        } else {
            isInserting = true
        }
        sdsSave(saveMode: isInserting ? .insert : .update, transaction: transaction)
    }

    // This method is used by "updateWith..." methods.
    //
    // This model may be updated from many threads. We don't want to save
    // our local copy (this instance) since it may be out of date.  We also
    // want to avoid re-saving a model that has been deleted.  Therefore, we
    // use "updateWith..." methods to:
    //
    // a) Update a property of this instance.
    // b) If a copy of this model exists in the database, load an up-to-date copy,
    //    and update and save that copy.
    // b) If a copy of this model _DOES NOT_ exist in the database, do _NOT_ save
    //    this local instance.
    //
    // After "updateWith...":
    //
    // a) Any copy of this model in the database will have been updated.
    // b) The local property on this instance will always have been updated.
    // c) Other properties on this instance may be out of date.
    //
    // All mutable properties of this class have been made read-only to
    // prevent accidentally modifying them directly.
    //
    // This isn't a perfect arrangement, but in practice this will prevent
    // data loss and will resolve all known issues.
    func anyUpdate(transaction: SDSAnyWriteTransaction, block: (TSPaymentModel) -> Void) {

        block(self)

        guard let dbCopy = type(of: self).anyFetch(uniqueId: uniqueId,
                                                   transaction: transaction) else {
            return
        }

        // Don't apply the block twice to the same instance.
        // It's at least unnecessary and actually wrong for some blocks.
        // e.g. `block: { $0 in $0.someField++ }`
        if dbCopy !== self {
            block(dbCopy)
        }

        dbCopy.sdsSave(saveMode: .update, transaction: transaction)
    }

    // This method is an alternative to `anyUpdate(transaction:block:)` methods.
    //
    // We should generally use `anyUpdate` to ensure we're not unintentionally
    // clobbering other columns in the database when another concurrent update
    // has occured.
    //
    // There are cases when this doesn't make sense, e.g. when  we know we've
    // just loaded the model in the same transaction. In those cases it is
    // safe and faster to do a "overwriting" update
    func anyOverwritingUpdate(transaction: SDSAnyWriteTransaction) {
        sdsSave(saveMode: .update, transaction: transaction)
    }

    func anyRemove(transaction: SDSAnyWriteTransaction) {
        sdsRemove(transaction: transaction)
    }

    func anyReload(transaction: SDSAnyReadTransaction) {
        anyReload(transaction: transaction, ignoreMissing: false)
    }

    func anyReload(transaction: SDSAnyReadTransaction, ignoreMissing: Bool) {
        guard let latestVersion = type(of: self).anyFetch(uniqueId: uniqueId, transaction: transaction) else {
            if !ignoreMissing {
                owsFailDebug("`latest` was unexpectedly nil")
            }
            return
        }

        setValuesForKeys(latestVersion.dictionaryValue)
    }
}

// MARK: - TSPaymentModelCursor

@objc
public class TSPaymentModelCursor: NSObject {
    private let transaction: GRDBReadTransaction
    private let cursor: RecordCursor<PaymentModelRecord>?

    init(transaction: GRDBReadTransaction, cursor: RecordCursor<PaymentModelRecord>?) {
        self.transaction = transaction
        self.cursor = cursor
    }

    public func next() throws -> TSPaymentModel? {
        guard let cursor = cursor else {
            return nil
        }
        guard let record = try cursor.next() else {
            return nil
        }
        return try TSPaymentModel.fromRecord(record)
    }

    public func all() throws -> [TSPaymentModel] {
        var result = [TSPaymentModel]()
        while true {
            guard let model = try next() else {
                break
            }
            result.append(model)
        }
        return result
    }
}

// MARK: - Obj-C Fetch

// TODO: We may eventually want to define some combination of:
//
// * fetchCursor, fetchOne, fetchAll, etc. (ala GRDB)
// * Optional "where clause" parameters for filtering.
// * Async flavors with completions.
//
// TODO: I've defined flavors that take a read transaction.
//       Or we might take a "connection" if we end up having that class.
@objc
public extension TSPaymentModel {
    class func grdbFetchCursor(transaction: GRDBReadTransaction) -> TSPaymentModelCursor {
        let database = transaction.database
        do {
            let cursor = try PaymentModelRecord.fetchCursor(database)
            return TSPaymentModelCursor(transaction: transaction, cursor: cursor)
        } catch {
            owsFailDebug("Read failed: \(error)")
            return TSPaymentModelCursor(transaction: transaction, cursor: nil)
        }
    }

    // Fetches a single model by "unique id".
    class func anyFetch(uniqueId: String,
                        transaction: SDSAnyReadTransaction) -> TSPaymentModel? {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            return TSPaymentModel.ydb_fetch(uniqueId: uniqueId, transaction: ydbTransaction)
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT * FROM \(PaymentModelRecord.databaseTableName) WHERE \(paymentModelColumn: .uniqueId) = ?"
            return grdbFetchOne(sql: sql, arguments: [uniqueId], transaction: grdbTransaction)
        }
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            block: @escaping (TSPaymentModel, UnsafeMutablePointer<ObjCBool>) -> Void) {
        anyEnumerate(transaction: transaction, batched: false, block: block)
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            batched: Bool = false,
                            block: @escaping (TSPaymentModel, UnsafeMutablePointer<ObjCBool>) -> Void) {
        let batchSize = batched ? Batching.kDefaultBatchSize : 0
        anyEnumerate(transaction: transaction, batchSize: batchSize, block: block)
    }

    // Traverses all records.
    // Records are not visited in any particular order.
    //
    // If batchSize > 0, the enumeration is performed in autoreleased batches.
    class func anyEnumerate(transaction: SDSAnyReadTransaction,
                            batchSize: UInt,
                            block: @escaping (TSPaymentModel, UnsafeMutablePointer<ObjCBool>) -> Void) {
        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            TSPaymentModel.ydb_enumerateCollectionObjects(with: ydbTransaction) { (object, stop) in
                guard let value = object as? TSPaymentModel else {
                    owsFailDebug("unexpected object: \(type(of: object))")
                    return
                }
                block(value, stop)
            }
        case .grdbRead(let grdbTransaction):
            do {
                let cursor = TSPaymentModel.grdbFetchCursor(transaction: grdbTransaction)
                try Batching.loop(batchSize: batchSize,
                                  loopBlock: { stop in
                                      guard let value = try cursor.next() else {
                                        stop.pointee = true
                                        return
                                      }
                                      block(value, stop)
                })
            } catch let error {
                owsFailDebug("Couldn't fetch models: \(error)")
            }
        }
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        anyEnumerateUniqueIds(transaction: transaction, batched: false, block: block)
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     batched: Bool = false,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        let batchSize = batched ? Batching.kDefaultBatchSize : 0
        anyEnumerateUniqueIds(transaction: transaction, batchSize: batchSize, block: block)
    }

    // Traverses all records' unique ids.
    // Records are not visited in any particular order.
    //
    // If batchSize > 0, the enumeration is performed in autoreleased batches.
    class func anyEnumerateUniqueIds(transaction: SDSAnyReadTransaction,
                                     batchSize: UInt,
                                     block: @escaping (String, UnsafeMutablePointer<ObjCBool>) -> Void) {
        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            ydbTransaction.enumerateKeys(inCollection: TSPaymentModel.collection()) { (uniqueId, stop) in
                block(uniqueId, stop)
            }
        case .grdbRead(let grdbTransaction):
            grdbEnumerateUniqueIds(transaction: grdbTransaction,
                                   sql: """
                    SELECT \(paymentModelColumn: .uniqueId)
                    FROM \(PaymentModelRecord.databaseTableName)
                """,
                batchSize: batchSize,
                block: block)
        }
    }

    // Does not order the results.
    class func anyFetchAll(transaction: SDSAnyReadTransaction) -> [TSPaymentModel] {
        var result = [TSPaymentModel]()
        anyEnumerate(transaction: transaction) { (model, _) in
            result.append(model)
        }
        return result
    }

    // Does not order the results.
    class func anyAllUniqueIds(transaction: SDSAnyReadTransaction) -> [String] {
        var result = [String]()
        anyEnumerateUniqueIds(transaction: transaction) { (uniqueId, _) in
            result.append(uniqueId)
        }
        return result
    }

    class func anyCount(transaction: SDSAnyReadTransaction) -> UInt {
        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            return ydbTransaction.numberOfKeys(inCollection: TSPaymentModel.collection())
        case .grdbRead(let grdbTransaction):
            return PaymentModelRecord.ows_fetchCount(grdbTransaction.database)
        }
    }

    // WARNING: Do not use this method for any models which do cleanup
    //          in their anyWillRemove(), anyDidRemove() methods.
    class func anyRemoveAllWithoutInstantation(transaction: SDSAnyWriteTransaction) {
        switch transaction.writeTransaction {
        case .yapWrite(let ydbTransaction):
            ydbTransaction.removeAllObjects(inCollection: TSPaymentModel.collection())
        case .grdbWrite(let grdbTransaction):
            do {
                try PaymentModelRecord.deleteAll(grdbTransaction.database)
            } catch {
                owsFailDebug("deleteAll() failed: \(error)")
            }
        }

        if shouldBeIndexedForFTS {
            FullTextSearchFinder.allModelsWereRemoved(collection: collection(), transaction: transaction)
        }
    }

    class func anyRemoveAllWithInstantation(transaction: SDSAnyWriteTransaction) {
        // To avoid mutationDuringEnumerationException, we need
        // to remove the instances outside the enumeration.
        let uniqueIds = anyAllUniqueIds(transaction: transaction)

        var index: Int = 0
        do {
            try Batching.loop(batchSize: Batching.kDefaultBatchSize,
                              loopBlock: { stop in
                                  guard index < uniqueIds.count else {
                                    stop.pointee = true
                                    return
                                  }
                                  let uniqueId = uniqueIds[index]
                                  index = index + 1
                                  guard let instance = anyFetch(uniqueId: uniqueId, transaction: transaction) else {
                                      owsFailDebug("Missing instance.")
                                      return
                                  }
                                  instance.anyRemove(transaction: transaction)
            })
        } catch {
            owsFailDebug("Error: \(error)")
        }

        if shouldBeIndexedForFTS {
            FullTextSearchFinder.allModelsWereRemoved(collection: collection(), transaction: transaction)
        }
    }

    class func anyExists(uniqueId: String,
                        transaction: SDSAnyReadTransaction) -> Bool {
        assert(uniqueId.count > 0)

        switch transaction.readTransaction {
        case .yapRead(let ydbTransaction):
            return ydbTransaction.hasObject(forKey: uniqueId, inCollection: TSPaymentModel.collection())
        case .grdbRead(let grdbTransaction):
            let sql = "SELECT EXISTS ( SELECT 1 FROM \(PaymentModelRecord.databaseTableName) WHERE \(paymentModelColumn: .uniqueId) = ? )"
            let arguments: StatementArguments = [uniqueId]
            return try! Bool.fetchOne(grdbTransaction.database, sql: sql, arguments: arguments) ?? false
        }
    }
}

// MARK: - Swift Fetch

public extension TSPaymentModel {
    class func grdbFetchCursor(sql: String,
                               arguments: StatementArguments = StatementArguments(),
                               transaction: GRDBReadTransaction) -> TSPaymentModelCursor {
        do {
            let sqlRequest = SQLRequest<Void>(sql: sql, arguments: arguments, cached: true)
            let cursor = try PaymentModelRecord.fetchCursor(transaction.database, sqlRequest)
            return TSPaymentModelCursor(transaction: transaction, cursor: cursor)
        } catch {
            Logger.error("sql: \(sql)")
            owsFailDebug("Read failed: \(error)")
            return TSPaymentModelCursor(transaction: transaction, cursor: nil)
        }
    }

    class func grdbFetchOne(sql: String,
                            arguments: StatementArguments = StatementArguments(),
                            transaction: GRDBReadTransaction) -> TSPaymentModel? {
        assert(sql.count > 0)

        do {
            let sqlRequest = SQLRequest<Void>(sql: sql, arguments: arguments, cached: true)
            guard let record = try PaymentModelRecord.fetchOne(transaction.database, sqlRequest) else {
                return nil
            }

            return try TSPaymentModel.fromRecord(record)
        } catch {
            owsFailDebug("error: \(error)")
            return nil
        }
    }
}

// MARK: - SDSSerializer

// The SDSSerializer protocol specifies how to insert and update the
// row that corresponds to this model.
class TSPaymentModelSerializer: SDSSerializer {

    private let model: TSPaymentModel
    public required init(model: TSPaymentModel) {
        self.model = model
    }

    // MARK: - Record

    func asRecord() throws -> SDSRecord {
        let id: Int64? = model.grdbId?.int64Value

        let recordType: SDSRecordType = .paymentModel
        let uniqueId: String = model.uniqueId

        // Properties
        let addressUuidString: String? = model.addressUuidString
        let createdTimestamp: UInt64 = model.createdTimestamp
        let isUnread: Bool = model.isUnread
        let mcIncomingTransaction: Data? = model.mcIncomingTransaction
        let mcLedgerBlockIndex: UInt64 = model.mcLedgerBlockIndex
        let memoMessage: String? = model.memoMessage
        let mobileCoin: Data? = optionalArchive(model.mobileCoin)
        let notificationMessageUniqueId: String? = model.notificationMessageUniqueId
        let paymentAmount: Data? = optionalArchive(model.paymentAmount)
        let paymentFailure: TSPaymentFailure = model.paymentFailure
        let paymentState: TSPaymentState = model.paymentState
        let paymentType: TSPaymentType = model.paymentType
        let requestUuidString: String? = model.requestUuidString

        return PaymentModelRecord(delegate: model, id: id, recordType: recordType, uniqueId: uniqueId, addressUuidString: addressUuidString, createdTimestamp: createdTimestamp, isUnread: isUnread, mcIncomingTransaction: mcIncomingTransaction, mcLedgerBlockIndex: mcLedgerBlockIndex, memoMessage: memoMessage, mobileCoin: mobileCoin, notificationMessageUniqueId: notificationMessageUniqueId, paymentAmount: paymentAmount, paymentFailure: paymentFailure, paymentState: paymentState, paymentType: paymentType, requestUuidString: requestUuidString)
    }
}

// MARK: - Deep Copy

#if TESTABLE_BUILD
@objc
public extension TSPaymentModel {
    // We're not using this method at the moment,
    // but we might use it for validation of
    // other deep copy methods.
    func deepCopyUsingRecord() throws -> TSPaymentModel {
        guard let record = try asRecord() as? PaymentModelRecord else {
            throw OWSAssertionError("Could not convert to record.")
        }
        return try TSPaymentModel.fromRecord(record)
    }
}
#endif
